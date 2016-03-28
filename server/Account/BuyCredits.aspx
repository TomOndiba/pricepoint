<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="BuyCredits.aspx.cs" Inherits="Account_BuyCredits" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="beforeform" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  
    <asp:Panel ID="pnlMessage" runat="server" CssClass="benefits" Visible="false"><p class="heading" runat="server" id="heading"><asp:Label ID="lblResult" runat="server" ></asp:Label></p></asp:Panel>
       				<!-- Form-Order -->
				<div class="form-order" runat="server" id="divForm">
					<!-- Packages -->
					<div class="packages">
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
					<div class="benefits">
						<p class="heading">Membership Benefits</p>
						<ul>
							<li><span class="icon"><img src="/img/icons/date.png" alt=""></span> Send a First Date Offer</li>
							<li><span class="icon"><img src="/img/icons/graph.png" alt=""></span> Unlock and Send Messages</li>
							<li><span class="icon"><img src="/img/icons/profile.png" alt=""></span> Profile Highlighted</li>
							<li><span class="icon"><img src="/img/icons/smile.png" alt=""></span> Profile Prominently Featured</li>
						</ul>
					</div>
					<!-- /Benefits -->

					<div class="head">
						<%--<a class="button button-paypal" href="#">Check out with <img src="/img/icons/paypal.png" width="90" alt=""></a>--%>
						<p class="h">Credit or Debit Card</p>
					</div>
					<div class="space">
						<div class="info">
							<p class="fn"><span>Discreete billing as Price Point Services</span></p>
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

								<div class="pure-g" id="divInputs">
                                    
                                    <div class="pure-u-1"><asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="error"  /></div>
                                    
									<div class="pure-u-1-2">
										<div class="form-line">
											<label for="txtFirstName">First Name
                                            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" Display="Dynamic"
                                            CssClass="requiredValidator" ErrorMessage="First Name is required." ToolTip="First Name is required." >First Name is required</asp:RequiredFieldValidator>

											</label>
											<asp:TextBox class="form-beige" ID="txtFirstName" runat="server" name="firstname" type="text" value=""></asp:TextBox>
										</div>
									</div>
									<div class="pure-u-1-2">
										<div class="form-line">
											<label for="txtLastName">Last Name
                                            <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" Display="Dynamic" 
                                            CssClass="requiredValidator" ErrorMessage="Last Name is required." ToolTip="Last Name is required.">Last Name is required</asp:RequiredFieldValidator>

											</label>
											<asp:TextBox class="form-beige" ID="txtLastName" runat="server" ></asp:TextBox>
										</div>
									</div>
									<div class="pure-u-1">
										<div class="form-line">
											<label for="txtCard">Card Number
                                            <asp:RequiredFieldValidator ID="rfvCard" runat="server" ControlToValidate="txtCard" Display="Dynamic" 
                                            CssClass="requiredValidator" ErrorMessage="Card Number is required." ToolTip="Card Number is required.">Card Number is required</asp:RequiredFieldValidator>
<asp:RegularExpressionValidator ID="regexCard" runat="server" ValidationExpression="^\d{14,19}$"  Display="Dynamic" 
                                        CssClass="requiredValidator" ControlToValidate="txtCard"  ErrorMessage="Invalid Card Number Format">Invalid Card Number Format</asp:RegularExpressionValidator>
											</label>
											<asp:TextBox  class="form-beige" placeholder="Credit or Debit Card Number" ID="txtCard" runat="server" ></asp:TextBox>
										</div>
									</div>
									<div class="pure-u-1-2">

									<div class="form-line">
											<label for="expires">Expiry Date (MM/YY)
                                            <asp:RequiredFieldValidator ID="rfvExpiryDate" runat="server" ControlToValidate="txtExpires" Display="Dynamic"
                                            CssClass="requiredValidator" ErrorMessage="Expiry Date is required." ToolTip="Expiry Date is required.">Expiry Date is required</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="regexExpiryDate" runat="server" ValidationExpression="^((0\d)|(1[012]))/\d\d$"  Display="Dynamic"
                                        CssClass="requiredValidator" ControlToValidate="txtExpires"  ErrorMessage="Invalid Expiry Date">Invalid Expiry Date</asp:RegularExpressionValidator>

											</label>
											<asp:TextBox runat="server" MaxLength="5" placeholder="MM/YY" class="form-beige" ID="txtExpires" ></asp:TextBox>
									</div>

									</div>
									<div class="pure-u-1-2">
										<div class="form-line">
											<label for="txtSecurityCode">Security Code
                                            <asp:RequiredFieldValidator ID="rfvSecurityCode" runat="server" ControlToValidate="txtSecurityCode" Display="Dynamic" 
                                            CssClass="requiredValidator" ErrorMessage="Security Code is required." ToolTip="Security Code is required.">Security Code is required</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="regexSecurityCode" runat="server" ValidationExpression="^\d{3,4}$"  Display="Dynamic" 
                                        CssClass="requiredValidator" ControlToValidate="txtSecurityCode"  ErrorMessage="Invalid Security Code Format">Invalid Security Code Format</asp:RegularExpressionValidator>
											</label>
											<asp:TextBox runat="server" class="form-beige" placeholder="CVV" ID="txtSecurityCode"></asp:TextBox>
										</div>
									</div>
									<div class="pure-u-1">
										<div class="form-line">
											<label for="txtAddress">Street Address
                                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" Display="Dynamic" 
                                            CssClass="requiredValidator" ErrorMessage="Street Address is required." ToolTip="Street Address is required.">Street Address is required</asp:RequiredFieldValidator>
											</label>
											<asp:TextBox runat="server" class="form-beige" ID="txtAddress" ></asp:TextBox>
										</div>
									</div>
									<div class="pure-u-1">
										<div class="form-line">
											<label for="ddlCountries">Country</label>
											<div class="select-beige">
                                                <asp:DropDownList CssClass="selectric" ID="ddlCountries" runat="server">
    <asp:ListItem Value="AU">Australia</asp:ListItem>
    <asp:ListItem Value="AT">Austria</asp:ListItem>
    <asp:ListItem Value="BS">Bahamas</asp:ListItem>
    <asp:ListItem Value="BE">Belgium</asp:ListItem>
    <asp:ListItem Value="BM">Bermuda</asp:ListItem>
    <asp:ListItem Value="CA">Canada</asp:ListItem>
    <asp:ListItem Value="KY">Cayman Islands</asp:ListItem>
    <asp:ListItem Value="CZ">Czech Republic</asp:ListItem>
    <asp:ListItem Value="DK">Denmark</asp:ListItem>
    <asp:ListItem Value="FI">Finland</asp:ListItem>
    <asp:ListItem Value="FR">France</asp:ListItem>
    <asp:ListItem Value="DE">Germany</asp:ListItem>
    <asp:ListItem Value="HK">Hong Kong</asp:ListItem>
    <asp:ListItem Value="IE">Ireland</asp:ListItem>
    <asp:ListItem Value="IT">Italy</asp:ListItem>
    <asp:ListItem Value="JP">Japan</asp:ListItem>
    <asp:ListItem Value="MC">Monaco</asp:ListItem>
    <asp:ListItem Value="NL">Netherlands</asp:ListItem>
    <asp:ListItem Value="NZ">New Zealand</asp:ListItem>
    <asp:ListItem Value="NO">Norway</asp:ListItem>
    <asp:ListItem Value="ES">Spain</asp:ListItem>
    <asp:ListItem Value="SE">Sweden</asp:ListItem>
    <asp:ListItem Value="CH">Switzerland</asp:ListItem>
    <asp:ListItem Value="AE">United Arab Emirates</asp:ListItem>
    <asp:ListItem Value="GB">United Kingdom</asp:ListItem>
    <asp:ListItem Value="US" Selected="True">United States</asp:ListItem>
    <asp:ListItem Value="VG">Virgin Islands (British)</asp:ListItem>
    <asp:ListItem Value="VI">Virgin Islands (U.S.)</asp:ListItem>
                                                </asp:DropDownList>
											</div>
										</div>
									</div>
									<div class="pure-u-1-2">
										<div class="form-line">
											<label for="txtCity">City
                                                <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" Display="Dynamic" 
                                            CssClass="requiredValidator" ErrorMessage="City is required." ToolTip="City is required.">City is required</asp:RequiredFieldValidator>
											</label>
											<asp:TextBox runat="server" class="form-beige" ID="txtCity"></asp:TextBox>
										</div>
									</div>
									<div class="pure-u-1-2">
										<div class="form-line">
											<label for="txtState">State
                                                <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="txtState" Display="Dynamic" 
                                            CssClass="requiredValidator" ErrorMessage="State is required." ToolTip="State is required.">State is required</asp:RequiredFieldValidator>
											</label>
                                            <div class="select-beige">
                                            <asp:DropDownList runat="server" ID="txtState" CssClass="form-beige selectric" >
                    <asp:ListItem Value="">Please select State or Province</asp:ListItem>
<asp:ListItem Value="AL">Alabama</asp:ListItem>
<asp:ListItem Value="AK">Alaska</asp:ListItem>
<asp:ListItem Value="AB">Alberta</asp:ListItem>
<asp:ListItem Value="AZ">Arizona</asp:ListItem>
<asp:ListItem Value="AR">Arkansas</asp:ListItem>
<asp:ListItem Value="BC">British Columbia</asp:ListItem>
<asp:ListItem Value="CA">California</asp:ListItem>
<asp:ListItem Value="CO">Colorado</asp:ListItem>
<asp:ListItem Value="CT">Connecticut</asp:ListItem>
<asp:ListItem Value="DE">Delaware</asp:ListItem>
<asp:ListItem Value="DC">District of Columbia</asp:ListItem>
<asp:ListItem Value="FL">Florida</asp:ListItem>
<asp:ListItem Value="GA">Georgia</asp:ListItem>
<asp:ListItem Value="HI">Hawaii</asp:ListItem>
<asp:ListItem Value="ID">Idaho</asp:ListItem>
<asp:ListItem Value="IL">Illinois</asp:ListItem>
<asp:ListItem Value="IN">Indiana</asp:ListItem>
<asp:ListItem Value="IA">Iowa</asp:ListItem>
<asp:ListItem Value="KS">Kansas</asp:ListItem>
<asp:ListItem Value="KY">Kentucky</asp:ListItem>
<asp:ListItem Value="LA">Louisiana</asp:ListItem>
<asp:ListItem Value="ME">Maine</asp:ListItem>
<asp:ListItem Value="MB">Manitoba</asp:ListItem>
<asp:ListItem Value="MD">Maryland</asp:ListItem>
<asp:ListItem Value="MA">Massachusetts</asp:ListItem>
<asp:ListItem Value="MI">Michigan</asp:ListItem>
<asp:ListItem Value="MN">Minnesota</asp:ListItem>
<asp:ListItem Value="MS">Mississippi</asp:ListItem>
<asp:ListItem Value="MO">Missouri</asp:ListItem>
<asp:ListItem Value="MT">Montana</asp:ListItem>
<asp:ListItem Value="NE">Nebraska</asp:ListItem>
<asp:ListItem Value="NV">Nevada</asp:ListItem>
<asp:ListItem Value="NB">New Brunswick</asp:ListItem>
<asp:ListItem Value="NH">New Hampshire</asp:ListItem>
<asp:ListItem Value="NJ">New Jersey</asp:ListItem>
<asp:ListItem Value="NM">New Mexico</asp:ListItem>
<asp:ListItem Value="NY">New York</asp:ListItem>
<asp:ListItem Value="NL">Newfoundland and Labrador</asp:ListItem>
<asp:ListItem Value="NC">North Carolina</asp:ListItem>
<asp:ListItem Value="ND">North Dakota</asp:ListItem>
<asp:ListItem Value="NT">Northwest Territories</asp:ListItem>
<asp:ListItem Value="NS">Nova Scotia</asp:ListItem>
<asp:ListItem Value="NU">Nunavut</asp:ListItem>
<asp:ListItem Value="OH">Ohio</asp:ListItem>
<asp:ListItem Value="OK">Oklahoma</asp:ListItem>
<asp:ListItem Value="ON">Ontario</asp:ListItem>
<asp:ListItem Value="OR">Oregon</asp:ListItem>
<asp:ListItem Value="PA">Pennsylvania</asp:ListItem>
<asp:ListItem Value="PE">Prince Edward Island</asp:ListItem>
<asp:ListItem Value="PR">Puerto Rico</asp:ListItem>
<asp:ListItem Value="QC">Quebec</asp:ListItem>
<asp:ListItem Value="RI">Rhode Island</asp:ListItem>
<asp:ListItem Value="SK">Saskatchewan</asp:ListItem>
<asp:ListItem Value="SC">South Carolina</asp:ListItem>
<asp:ListItem Value="SD">South Dakota</asp:ListItem>
<asp:ListItem Value="TN">Tennessee</asp:ListItem>
<asp:ListItem Value="TX">Texas</asp:ListItem>
<asp:ListItem Value="UT">Utah</asp:ListItem>
<asp:ListItem Value="VT">Vermont</asp:ListItem>
<asp:ListItem Value="VA">Virginia</asp:ListItem>
<asp:ListItem Value="WA">Washington</asp:ListItem>
<asp:ListItem Value="WV">West Virginia</asp:ListItem>
<asp:ListItem Value="WI">Wisconsin</asp:ListItem>
<asp:ListItem Value="WY">Wyoming</asp:ListItem>
<asp:ListItem Value="YT">Yukon</asp:ListItem>

                </asp:DropDownList>
</div>
										</div>
									</div>
									<div class="pure-u-1">
										<div class="form-line">
											<label for="txtZip">Zip / Postal Code
                                                <asp:RequiredFieldValidator ID="rfvZip" runat="server" ControlToValidate="txtZip" Display="Dynamic" 
                                            CssClass="requiredValidator" ErrorMessage="Zip / Postal Code is required." ToolTip="Zip / Postal Code is required.">Zip / Postal Code is required</asp:RequiredFieldValidator>
											</label>
											<asp:TextBox runat="server" class="form-beige" id="txtZip"></asp:TextBox>
										</div>
									</div>
								</div>

								<p class="total">Total: $<span class="t">49</span></p>
								<p class="form-submit">
									<asp:Button ID="btnSubmit" runat="server" class="button" Text="Submit Order" OnClick="btnSubmit_Click"  /><%--OnClientClick="if(Page_ClientValidate('Inivitation')){this.disabled=true;}"  CausesValidation="true" --%>
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

     function CardValidatorsEnable(isEnable)
        {
         var myVal = document.getElementById('<%= this.rfvFirstName.ClientID %>');
         if (myVal == null) return;
            myVal.enabled = isEnable;
           // myVal.isvalid = !isEnable;
            //ValidatorEnable(myVal, isEnable);
            myVal = document.getElementById('<%= this.rfvLastName.ClientID %>');
            myVal.enabled = isEnable;
            myVal = document.getElementById('<%= this.rfvCard.ClientID %>');
            myVal.enabled = isEnable;
            myVal = document.getElementById('<%= this.regexCard.ClientID %>');
            myVal.enabled = isEnable;
            myVal = document.getElementById('<%= this.rfvExpiryDate.ClientID %>');
            myVal.enabled = isEnable;
            myVal = document.getElementById('<%= this.regexExpiryDate.ClientID %>');
            myVal.enabled = isEnable;
            myVal = document.getElementById('<%= this.rfvAddress.ClientID %>');
            myVal.enabled = isEnable;
            myVal = document.getElementById('<%= this.rfvSecurityCode.ClientID %>');
            myVal.enabled = isEnable;
            myVal = document.getElementById('<%= this.rfvCity.ClientID %>');
            myVal.enabled = isEnable;
            myVal = document.getElementById('<%= this.rfvState.ClientID %>');
            myVal.enabled = isEnable;
            myVal = document.getElementById('<%= this.rfvZip.ClientID %>');
            myVal.enabled = isEnable;
        }

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

    //Put our input DOM element into a jQuery Object
    var $jqDate = jQuery('#<%= txtExpires.ClientID%>');

    //Bind keyup/keydown to the input
    $jqDate.bind('keyup', 'keydown', function (e) {

        //To accomdate for backspacing, we detect which key was pressed - if backspace, do nothing:
        if (e.which !== 8) {
            var numChars = $jqDate.val().length;
            if (numChars === 2 ) {
                var thisVal = $jqDate.val();
                thisVal += '/';
                $jqDate.val(thisVal);
            }
            if (numChars === 5)
            {
                $('#<%=txtSecurityCode.ClientID%>').focus();
            }
        }
    });

</script>  

</asp:Content>



