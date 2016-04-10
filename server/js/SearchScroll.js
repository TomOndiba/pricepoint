var pageIndex = 1;
var pageCount;
var locked = false;
var filterjson = '';

var Filter = {
    agemin: 0,
    agemax: 0,
    distancemax: 0,
    orderby: 0,
    withphotos: false,
    body: [],
    ethnicity: []
}


function resetfilter()
{
    document.getElementById('searchjson').setAttribute("value", "DEFAULT");
    document.forms[0].submit();
}

function SubmitSearch(result)
{
    document.getElementById('searchjson').setAttribute("value",JSON.stringify(result, null, 0));

    document.forms[0].submit();
}

function DoSearch()
{
    Filter.agemax = 29;
    Filter.agemin = 18;
    window.location.href = '/Search?f=' + encodeURIComponent(JSON.stringify(Filter));
    return false;
}

$(window).scroll(function () {
//    if ($(window).scrollTop() == $(document).height() - $(window).height())
    if ($(document).height() - $(window).height() - $(window).scrollTop()<220)
    {
        GetRecords();
    }
});

function setButtonSwitch(table, button_switch) {
    $(".SW", table).attr("class", "cell SW " + button_switch);
}
function MakeOfferDone(panel, amount) {
    setButtonSwitch(panel, 'SW_OFFERSENT');
}

function GetRecords() {
    if (locked == true || pageIndex==0) return;
    pageIndex++;
    if (pageIndex >= 2) {
        $("#loader").show();
        locked = true;
        $.ajax({
            type: "POST",
            url: "Search.aspx/GetUsersPage",
            data: '{pageIndex: ' + pageIndex + ',filter:\'' + escape(filterjson)+ '\'}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {
                alert(response.d);
                locked = false;
            },
            error: function (response) {
                alert(response.d);
                locked = false;
            }
        });
    }
}
function viewprofile(e)
{
    id = $(e).parents('.item').attr("data-id");
    window.location.href = '/Account/ViewProfile?id=' + id;
    return false;
}

function AcceptOffer(e) {
    id = $(e).parents('.item').attr("data-id");
    alert(e);
}


function OnSuccess(response) {
    var xmlDoc = $.parseXML(response.d);
    var xml = $(xmlDoc);
    var filter = xml.find("filter");
    filterjson = filter.find("json").text();
    var customers = xml.find("U");
    if (customers.length == 0) pageIndex = 0; //done
    customers.each(function () {
        var customer = $(this);
        var table = $("#usersdiv div").eq(0).clone(true);
        $(".photoM", table)[0].src = customer.find("MainPhoto").text();
        $(".dist", table).html(customer.find("dis").text());
        $(".name", table).html(customer.find("usr").text());
        $(".loc", table).html(customer.find("plc").text());
        $(".age", table).html(customer.find("age").text());
        $(".status", table).html(customer.find("tit").text());
        $(".dist", table).html(customer.find("dis").text());
        if (customer.find("Favorite").text() == "1")
            $(".js-favorite", table).addClass("active");
        else $(".js-favorite", table).removeClass("active");

        if (customer.find("wink").text() == "1")
            $(".js-wink", table).addClass("active");
        else $(".js-wink", table).removeClass("active");

        table.attr("data-id", customer.find("id_user").text());
        table.attr("data-user", customer.find("usr").text());

        var button_switch = customer.find("button_switch").text();
        setButtonSwitch(table, button_switch);

        
        $(".rib-wrapper", table).css('display', customer.find("online").text() == "1" ? 'block' : 'none');

        $(".vip", table).css('display', customer.find("VIP").text() == "Y" ? 'block' : 'none');


        $('.js-popup', table).magnificPopup({
            type: 'ajax',
            callbacks: {
                ajaxContentAdded: function () {
                    initForms(this.content, this);
                }
            }
        });

//        HookupUnlockConfirmation(table);

        $("#usersdiv").append(table);





    });
    $("#loader").hide();


    locked = false;
}

