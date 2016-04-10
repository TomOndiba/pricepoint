<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CreditCardForm.ascx.cs" Inherits="Account_CreditCardForm" %>
<div class="pure-g" id="divInputs">
                                    
                                    
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
											<label for="expires">Expiry Date <span class="expirydate_MMYY">(MM/YY)</span>
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
<asp:ListItem Value=""></asp:ListItem>
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

<script type="text/javascript">

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