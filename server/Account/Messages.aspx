<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Messages.aspx.cs" Inherits="Account_Messages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<!-- Resents -->
<section class="resents">
<h2 class="h2 heading">Recent Conversations</h2>
    <asp:Repeater ID="Repeater1" runat="server">
        <ItemTemplate>

				<div class='<%# GetClass((int)Eval("news"),Eval("id_user_unlocked"))%>'>
					<p class="head"><a href='/Account/ViewProfile.aspx?id=<%#Eval("id_user_with") %>'><strong><%# Eval("username") %></strong> / <span class="small"><%# Eval("place") %></span></a> <time class="timeago time" datetime="<%# (new DateTime(((DateTime)Eval("lastmessage")).Ticks, DateTimeKind.Local)).ToString("o")%>"><%# Eval("lastmessage").ToString() %></time></p>
					<div class="panel-space">
						<span class="fn" runat="server" visible='<%#((int)Eval("news"))>0%>'>
                            <%# Eval("locked").ToString()=="Locked" && MyUtils.IsMale ? "Locked":"New"%>
						</span>
						<a class="photo" href='/Account/ViewProfile.aspx?id=<%#Eval("id_user_with") %>'><img src='<%# MyUtils.GetImageUrl(Eval("MainPhoto"),MyUtils.ImageSize.TINY) %>' width="76" height="76" alt=""></a>
						<p class="name" style="font-size: 20px;padding-top: 7px;" ><%# GetDescription((int)Eval("messages"),(int)Eval("news")) %></p>



<asp:Button ID="but"  class="button button-blue" Text='<%#"Unlock for "+ Eval("credits") +" credits"%>' CommandArgument='<%#Eval("id_offer") %>' runat="server" Visible='<%# Eval("locked").ToString()=="Locked" && MyUtils.IsMale %>' OnClick="but_Click"></asp:Button>
<asp:Button ID="Button1"  class="button" Text='Send Message' runat="server" CommandArgument='<%#Eval("id_offer") %>' Visible='<%# Eval("locked").ToString()=="Unlocked" || MyUtils.IsFemale %>' OnClick="but_Click"></asp:Button>


					</div>
				</div>
				<!--div class="panel panel-locked">
					<p class="head">New message from <a href="person.html">Manuella23</a> <time class="time">Sent: 4d ago</time></p>
					<div class="panel-space">
						<span class="fn">locked</span>
						<a class="photo" href="person.html"><img src="img/catalog/2.jpg" width="76" height="76"  alt=""></a>
						<p class="name"><strong>Manuella23</strong> <span class="small">California, LA</span></p>
						<a class="button button-blue" href="#">Unlock 25 Credits</a>
					</div>
				</!--div>
				<div class="panel">
					<p class="head">Message from <a href="person.html">Dana</a> <time class="time">Sent: 2h ago</time></p>
					<div class="panel-space">
						<a class="photo" href="person.html"><img src="img/catalog/3.jpg" width="76" height="76" alt=""></a>
						<p class="name"><strong>Dana</strong> <span class="small">Lugoj, TM</span></p>
						<a class="button" href="messages.html">Read Message</a>
					</div>
				</div-->


        </ItemTemplate>
    </asp:Repeater>
    <asp:Label runat="server" ID="empty"></asp:Label>
</section>
<!-- /Resents -->

    <script type="text/javascript">
        jQuery(document).ready(function () {
            jQuery("time.timeago").timeago();
        });
    </script>

</asp:Content>

