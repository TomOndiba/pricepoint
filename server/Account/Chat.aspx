﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Chat.aspx.cs" Inherits="Messages_Chat" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        /*hotfix*/
        div.space {
            height: 100%;
        }


        .conversation .img-gift {
            width: 53px;
            height: 53px;
            display: inline-block;
            cursor: default;
        }

        .conversation .img-gifts {
            margin-top: 10px;
        }

        .conversation .congrats {
            display: block;
            margin-top: 5px;
            margin-bottom: 5px;
            font-size: 11pt;
        }
    </style>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="bottom" runat="Server">
    <script type="text/javascript">

        var status = { completed: true };
        $(function () {
            if (status.completed === false)
                return;
            $("#send_message").click(function () {
                status.completed = false;
                setTimeout(function () {
                    sendMessage(status);
                })

            });
            if ($('.presents-female').length > 0) {
                $('.conversation-page').addClass('conversation-page-female');
            }
        });

        $.urlParam = function (name) {
            var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
            if (results == null) {
                return null;
            }
            else {
                return results[1] || 0;
            }
        };
        //invokes page method with AJAX
        function invoke(method, data, successCallback, errorCallBack) {
            var pagePath = window.location.pathname;
            $.ajax({
                type: "POST",
                url: "Chat.aspx/" + method,
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(data),
                dataType: "json",
                success: function (result, status) {
                    if (typeof (result) === "string")
                        result = JSON.parse(result);
                    successCallback(result.d);
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }

        //adds new message
        function addArticle(message, from, time, my, giftIds) {
            var list = $(".conversation div.space");
            var template = '<article class="entry {{notmy}}">\
                              <p class="author">\
                                {{from}}\
                                    <time class="timeago time" datetime="{{time}}"></time>\
                              </p>\
                              <p class="message">{{message}}</p>\
                            </article>';

            template = template.replace('{{from}}', from);
            template = template.replace('{{message}}', message);
            template = template.replace('{{time}}', time);
            if (my)
                template = template.replace('{{notmy}}', '');
            else {
                template = template.replace('{{notmy}}', 'entry-interlocutor');
            }
            var article = $(template);

            //adding gifts
            if (giftIds && giftIds.length > 0) {
                var msggifts = my ? "You have sent gifts!" : "Congratulations, you got gifts!";
                var congrats = "<span class='congrats'>" + msggifts + "</span>";

                var checkboxes = $('.form-message .list .checkbox-gift :checkbox').filter(function (i, e) {
                    return giftIds.indexOf($(e).val()) >= 0
                }).parent().clone();
                var gifts = checkboxes.find("img").addClass("img-gift");
                var giftDiv = $("<div class='img-gifts'>");
                gifts.appendTo(giftDiv);
                giftDiv.appendTo(article)
                $(congrats).appendTo(article);
            }


            list.append(article);

            jQuery("time.timeago", article).timeago()
        }

        var lastMessageId = 0;
        var onlineflag = $('div.onlineflag');
        function SetOnlineFlag(online)
        {
            if (!online) onlineflag.hide(); else onlineflag.show();
        }

        function runPolling(initial) {
            if (initial) lastMessageId = 0;
            var newMessage = false;
            invoke("GetChatHistory", { toUser: $.urlParam("id"), lastMessageId: lastMessageId }, function (data) {
                var gotmessage = false;
                for (var i = 0; i < data.length; i++) {
                    var item = data[i];
                    if (item.Text == "REDIRTOLOGIN") {
                        window.location.href = '/Login';
                        return;
                    }
                    if (item.Text == "ONLINE:Y") {
                        SetOnlineFlag(true);
                        continue;
                    }
                    if (item.Text == "ONLINE:N") {
                        SetOnlineFlag(false);
                        continue;
                    }
                    gotmessage = true;
                    var gifts = [];
                    if (item.Gifts) {
                        gifts = item.Gifts.split(',');
                    }
                    if (item.Id > lastMessageId) {
                        addArticle(item.Text.replace(/\n/g, '<br/>'), item.From.Name, item.Sent, item.IsFromMe, gifts);
                        if (!item.IsFromMe)
                            newMessage = true;
                    }
                    lastMessageId = item.Id;
                }
                if (gotmessage)
                {
                    var x = $("div.space article:last()").get(0);
                    if (typeof x != 'undefined') x.scrollIntoView();
                }

                //new message recieved, playing sound
                if (!initial && newMessage) {
                    var audio = new Audio('sound.mp3');
                    $(audio).bind("ended", function () {
                        if(audio.played.length == 0)
                        {
                            var audio2 = new Audio('sound.wav');
                            audio2.play();
                        }
                    });
                    audio.play();
                }

            })
        }

        runPolling(true);

        function sendMessage(status) {
            var msg = $("#message").val();
            if (msg == "")
                return;

            var checkedGifts = $('.checkbox-gift :checkbox').filter(':checked').map(function (i, e) { return $(e).val(); });
            var gifts = "";
            if (checkedGifts && checkedGifts.length > 0) {
                gifts = checkedGifts.toArray().join();

                var cr = CheckGiftCredits(gifts);
                if (!cr) return;

            }

            invoke("SendMessage", { message: msg, toUser: $.urlParam("id"), giftIds: gifts }, function (data) {
                setCredits(data.Credits);
                runPolling();
                $("#message").val("");
                $('.checkbox-gift :checkbox').filter(':checked').removeAttr('checked').closest('label').removeClass('checked');
                status.completed = true;
            }, function () {
                status.completed = true;
            });
        }

        setInterval(function () {
            runPolling();
        }, 7000)

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <!-- Aside -->
    <aside class="aside">
        <div class="communication">
            <p class="head">Communication Tips</p>
            <ul>
                <li>Your goal here is to set up a date to meet in person.</li>
                <li>Suggest a specific place, day and time.</li>
                <li>Never send money via Western Union or PayPal in advance.</li>
            </ul>
        </div>
    </aside>

    <!-- Conversation -->
    <div class="conversation">
        <p class="head">Send a Message to <%=R["username"] %></p>
        <div class="space">
        </div>
    </div>
    <!-- /Conversation -->

    <!-- Form-message -->
    <div class="form-message">

        <figure class="photo">
            <a class="link" href='<%=Utils.GetProfileLink(R,"id_user")%>'>
                <img src='<%=MyUtils.GetImageUrl(R,MyUtils.ImageSize.SMALL)%>' width="160" height="160" alt=""/>
                <div <%=MyUtils.IsOnline(ID_USER_CHATWITH) ? "":"style='display:none'"%> class="rib-wrapper onlineflag"><div class="rib">Online</div></div>
                <span class="price">&#36;<%=Convert.ToInt32(Offer["Amount"]) %></span>
            </a>
        </figure>
        <div class="text">
            <p class="name"><a href='<%=Utils.GetProfileLink(R,"id_user")%>'><%=R["username"] %></a> <span class="small"><%=R["age"] %> / <%=R["place"] %></span></p>
            <p class="form-line">
                <textarea id="message" placeholder="Type your message here and click on the Send Mesage button" name="message" maxlength="500" required></textarea>
            </p>
            <span class="note" runat="server" id="note">Sex is not expected on the first date. Always be respectful to ladies.</span>
            <button class="button" type="button" id="send_message">Send Message</button>
        </div>

        <div class="presents <%=MyUtils.GetUserField("sex").ToString()=="F" ? "presents-female" :""%>">
            <p class="h">
                <strong>Make her Smile :)</strong>
                <br>
                Attach a virtual gift!
                <br>
                Only 5 credits per gift
            </p>
            <div class="list">
                <div class="cell">
                    <label class="checkbox checkbox-gift">
                        <input type="checkbox" value="1">
                        <img src="/img/gifts/1-(90x90).png" width="90" alt="">
                    </label>
                </div>
                <div class="cell">
                    <label class="checkbox checkbox-gift">
                        <input type="checkbox" value="2">
                        <img src="/img/gifts/2-(90x90).png" width="90" alt="">
                    </label>
                </div>
                <div class="cell">
                    <label class="checkbox checkbox-gift">
                        <input type="checkbox" value="3">
                        <img src="/img/gifts/3-(90x90).png" width="90" alt="">
                    </label>
                </div>
                <div class="cell">
                    <label class="checkbox checkbox-gift">
                        <input type="checkbox" value="4">
                        <img src="/img/gifts/4-(90x90).png" width="90" alt="">
                    </label>
                </div>
                <div class="cell">
                    <label class="checkbox checkbox-gift">
                        <input type="checkbox" value="5">
                        <img src="/img/gifts/5-(90x90).png" width="90" alt="">
                    </label>
                </div>
                <div class="cell">
                    <label class="checkbox checkbox-gift">
                        <input type="checkbox" value="6">
                        <img src="/img/gifts/6-(90x90).png" width="90" alt="">
                    </label>
                </div>
            </div>
        </div>
    </div>
    <!-- /Form-message -->


</asp:Content>

