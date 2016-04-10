<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Upgrade.aspx.cs" Inherits="Account_BuyCredits" %>

<%@ Register Src="~/Account/CreditCardForm.ascx" TagPrefix="uc1" TagName="CreditCardForm" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="beforeform" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  
    <asp:Panel ID="pnlMessage" runat="server" CssClass="benefits" Visible="false"><p class="heading" runat="server" id="heading"><asp:Label ID="lblResult" runat="server" ></asp:Label></p></asp:Panel>
       				<!-- Form-Order -->
				<div class="form-order" runat="server" id="divForm">
					<!-- Packages -->
					<div class="packages" runat="server" id="packages">
						<div class="pure-g">
							<div class="pure-u-1-3 pure-u-lg-8-24">
								<div class="panel active" data-value="1" data-price="49">
									<p class="head">&#36;49</p>
									<div class="panel-space">
										<p class="small">One Time Charge</p>
										<p class="credits">100 credits</p>
										<a class="button selected" href="#select"><span class="block">Package</span> Selected</a>
										<a class="button button-blue button-select" href="#select"><span class="block">Select</span> Package</a>
										<input type="hidden" value="1" />
										<p class="name">Basic</p>
									</div>
								</div>
							</div>
							<div class="pure-u-1-3 pure-u-lg-8-24">
								<div class="panel" data-value="2" data-price="99">
									<p class="head">&#36;99</p>
									<div class="panel-space">
										<p class="small">One Time Charge</p>
										<p class="credits">450 credits</p>
										<a class="button selected" href="#select"><span class="block">Package</span> Selected</a>
										<a class="button button-blue button-select" href="#select"><span class="block">Select</span> Package</a>
										<input type="hidden" value="2" />
										<p class="name">VIP Gold</p>
									</div>
								</div>
							</div>
							<div class="pure-u-1-3 pure-u-lg-8-24">
								<div class="panel" data-value="3" data-price="199">
									<p class="head">&#36;199</p>
									<div class="panel-space">
										<p class="small">One Time Charge</p>
										<p class="credits">1000 credits</p>
										<a class="button selected" href="#select"><span class="block">Package</span> Selected</a>
										<a class="button button-blue button-select" href="#select"><span class="block">Select</span> Package</a>
										<input type="hidden" value="3" />
										<p class="name">VIP Platinum</p>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- /Packages -->

					<!-- Benefits -->
					<div class="benefits"  id="benefits_male" runat="server">
						<p class="heading">Membership Benefits</p>
						<ul>
							<li><span class="icon"><img src="/img/icons/date.png" alt=""></span> Send a First Date Offer</li>
							<li><span class="icon"><img src="/img/icons/graph.png" alt=""></span> Unlock and Send Messages</li>
							<li><span class="icon"><img src="/img/icons/profile.png" alt=""></span> Profile Highlighted</li>
							<li><span class="icon"><img src="/img/icons/smile.png" alt=""></span> Profile Prominently Featured</li>
						</ul>
					</div>


					<div class="benefits" id="benefits_female" runat="server" >
						<p class="heading">Membership Benefits</p>
						<ul>
							<li><span class="icon"><img src="/img/icons/date.png" alt=""></span> Get More Date Offers</li>
							<li><span class="icon"><img src="/img/icons/smile.png" alt=""></span> Profile Prominently Featured</li>
							<li><span class="icon"><img src="/img/icons/profile.png" alt=""></span> Profile Highlighted</li>
							<li><span class="icon"><img src="/img/icons/graph.png" alt=""></span> Unlimited Name Your Price Offers</li>
						</ul>

<div id="PRICING" style="float:left;width:90%;clear:both;margin-left:5%;margin-bottom:15px" runat="server">
<div style="padding:10px;font-size:25px;float:left;width:100%;background-color:#fafafa"><DIV>Payment</DIV></div>
<div style="border-bottom:solid 1px silver; padding:10px;clear:both;width:100%;height:40px; "><div style="float:left;">Monthly Service</div><div id="MONTHLYFEE" runat="server" style="float:right;font-weight:bold"><%=MyUtils.MonthlyFee.ToString("c")%></div></div>
<div style="padding:10px;clear:both;width:100%;height:40px; "><div style="float:left;">
                            Your credit card will be billed every month a service fee of <%=MyUtils.MonthlyFee.ToString("c")%> until you cancel. You may cancel at any time without further obligation by visiting the settings page and clicking "cancel paid membership" or calling <nobr><%=ConfigurationManager.AppSettings["PHONE"] %></nobr> or emailing <%=ConfigurationManager.AppSettings["EMAIL"] %> <br />

                                                              </div>

                                                              </div>
 		
</div>
<p class="text" style="clear:both"></p>

					</div>
					<!-- /Benefits -->

					<div class="head">
						<%--<a class="button button-paypal" href="#">Check out with <img src="/img/icons/paypal.png" width="90" alt=""></a>--%>
						<p class="h">Credit or Debit Card</p>
					</div>
					<div class="space">
						<div class="info">
							<p class="fn"><span>Discreete billing as "<b>Price Point Services</b>"</span></p>
							<img src="/img/icons/mastercard.jpg" width="44" height="28" alt="">
							<img src="/img/icons/visa.jpg" width="44" height="28" alt="">
							<img src="/img/icons/discover.jpg" width="44" height="28" alt="">
							<img src="/img/icons/express.jpg" width="44" height="28" alt="">
						</div>
						<input type="hidden" name="package" value="1" runat="server" id="hiddenPackage"/>
						<div class="pure-g">
							<div class="pure-u-1 pure-u-md-12-24">
                                
                                <div class="cardselect" id="rblistCardSelect" runat="server">
                                    <input type="radio" id="radioOldCard" name="rCardSelect" value="1" style="-webkit-appearance: radio" />
                                    <label for="radioOldCard">Use my credit card ending with <%= LAST_DIGITS%></label>
                                    <br />
                                    <input type="radio" id="radioNewCard" name="rCardSelect" value="2" style="-webkit-appearance: radio"/>
                                    <label for="radioNewCard">Enter New Credit Card Info</label>

                                    <input type="hidden" runat="server" id="hiddenCardSelect" />
                                </div>

								



                                <uc1:CreditCardForm runat="server" ID="CreditCardForm" />






								<p class="total">Total: $<span class="t"><%=total %></span></p>
								<p class="form-submit">
									<asp:Button ID="btnSubmit" runat="server" class="button" Text="Submit Order" OnClick="btnSubmit_Click"  />
                                    <input type="button" value="Submitting..." class="button" id="btnFake" disabled="true"  style="display: none"/>
								</p>
								<p class="fn"><span>All sales are final – absolutely no refunds</span></p>
							</div>
						</div>
					</div>
				</div>
				<!-- /Form-Order -->
    <asp:Button ID="Button1" runat="server" Text="Button" Visible="false" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="bottom" Runat="Server">

        
<script type="text/javascript">

    var lastDigits = "<%= LAST_DIGITS%>";

    if (lastDigits == '') {
        $("#ContentPlaceHolder1_rblistCardSelect").hide();
        $('#divInputs').show();
        CardValidatorsEnable(true);
    }
    else {
        $("#ContentPlaceHolder1_rblistCardSelect").show();
        $('#divInputs').hide();
        CardValidatorsEnable(false);
    }

    <%if (!IsPostBack)
    { %>
   
    if (lastDigits = ! '') {
        var $radio1 = $('input:radio[id=radioOldCard]');
        $radio1.prop('checked', true);
        $("#ContentPlaceHolder1_hiddenCardSelect").val('1')
    }

    <%}
    else
    {%>
    if (lastDigits != '') {
        if ($("#ContentPlaceHolder1_hiddenCardSelect").val() == "1") {
            var $radio1 = $('input:radio[id=radioOldCard]');
            $radio1.prop('checked', true);
            $("#divInputs").hide();
            CardValidatorsEnable(false);
        }
        else {
            var $radio1 = $('input:radio[id=radioNewCard]');
            $radio1.prop('checked', true);
            $("#divInputs").show();
            CardValidatorsEnable(true);
        }
    }

    $(".panel", ".packages").each(function () {
        $(this).removeClass('active');
        if ($(this).attr('data-value') == $("#ContentPlaceHolder1_hiddenPackage").val()) {
            $(this).addClass('active');
            $('.total .t').html($(this).data('price'));
        }
    });

    <% } %>

    $("input[name='rCardSelect']", $('.cardselect')).change(
    function (e) {
        if ($(this).val() === '1') {
            $("#divInputs").hide();
            CardValidatorsEnable(false);
        } else if ($(this).val() === '2') {
            $("#divInputs").show();
            CardValidatorsEnable(true);
        }
        $("#ContentPlaceHolder1_hiddenCardSelect").val($(this).val());
    });


    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () { $("img[src='/img/loading.gif']").remove(); });

    $('form').submit(function () {
        if (Page_IsValid) {
            var but = $(this).find("#<%= btnSubmit.ClientID%>");
            
            //but.prop('disabled', true);
            but.hide();
            $(this).find("#btnFake").show();
            //but.val('Submitting...');
        }
    });

</script>  

</asp:Content>



