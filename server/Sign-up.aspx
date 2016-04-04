<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" ViewStateMode="Disabled" EnableViewState="false" EnableEventValidation="false" AutoEventWireup="true" CodeFile="Sign-up.aspx.cs" Inherits="Sign_up" %>

<%@ Register Src ="~/Account/BirthdayCtrl.ascx" TagPrefix="uc" TagName="Birthday" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
            <div class="pure-g">
				<div class="pure-u-1 pure-u-sm-14-24 pure-u-lg-11-24">
					<div class="form form-register">
						<div class="form-space">
							<h2 class="form-head">Join Us Today!</h2>
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="error" />
							<div class="form-line">
								<label for="gender">I am</label>
								<div class="select-large">
                                    <asp:DropDownList runat="server" CssClass="select" ID="ddlGender">
                                        <asp:ListItem Value="">Select...</asp:ListItem>
                                        <asp:ListItem Value="M">Generous man seeking beautiful women</asp:ListItem>
                                        <asp:ListItem Value="F">Attractive woman seeking generous men</asp:ListItem>
                                    </asp:DropDownList>
								</div>
							</div>
							<div class="form-line">
								<label for="txtEmail">Email Address
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic"
                                            CssClass="requiredValidator" ErrorMessage="Email Address is required." ToolTip="Email Address is required.">Email Address is required</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ValidationExpression="^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$"  Display="Dynamic"
                                        CssClass="requiredValidator" ControlToValidate="txtEmail"  ErrorMessage="Invalid Email Format">Invalid Email Format</asp:RegularExpressionValidator>
								</label>
                                <asp:TextBox CssClass="large" id="txtEmail" runat="server" placeholder="" />
							</div>
							<div class="form-line">
								<label for="txtName">Username
                                <asp:RequiredFieldValidator ID="rfvUserName" runat="server" ControlToValidate="txtName" Display="Dynamic"
                                            CssClass="requiredValidator" ErrorMessage="Username is required." ToolTip="Username is required.">Username is required</asp:RequiredFieldValidator>
								</label>
                                <asp:TextBox CssClass="large" id="txtName" runat="server" placeholder="" />
							</div>
							<div class="form-line">
								<label for="txtPassword">Password
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" Display="Dynamic"
                                            CssClass="requiredValidator" ErrorMessage="Password is required." ToolTip="Password is required.">Password is required</asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator Display = "Dynamic" ControlToValidate = "txtPassword" ID="RegularExpressionValidator2" CssClass="requiredValidator"
                                    ValidationExpression = "^[\s\S]{6,}$" runat="server" ErrorMessage="Minimum 6 characters required for password.">Minimum 6 characters required for password.</asp:RegularExpressionValidator>
								</label>
                                <asp:TextBox CssClass="large" id="txtPassword" runat="server" TextMode="Password"  placeholder="" />
							</div>
                            <uc:Birthday ID="birthday" runat="server"/>
							<div class="form-submit">
                                <asp:Button runat="server" ID="btnSignUp" CssClass="button button-large button-sign" Text="Sign up" OnClick="btnSignUp_Click" />
								<span class="small">By signing up, you agree to the <a class="blue" href="/Terms" target="_blank">Terms of Service</a> and <a class="blue" href="/Privacy" target="_blank">Privacy Policy</a>.</span>
							</div>
						</div>

						<p class="form-important">
							<strong>Important:</strong> We are strictly an online dating website. Do not use this website to promote or seek out Escort services. Any and all commercial or illegal activities are prohibited. Members who engage in such activities or violate our “no escort” policy will be permanently banned from our website.
						</p>
					</div>
				</div>
			</div>

</asp:Content>