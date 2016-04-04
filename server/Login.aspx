<%@ Page Title="Log In" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="True"
    CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
      <div class="info" id="welcome" runat="server" visible="false">
        <b>Welcome to PricePointDating.com!</b><br />
        <br />We've got your registration confirmed! 
    </div>

    <asp:Login ID="LoginUser" runat="server" EnableViewState="false" RenderOuterTable="false" onauthenticate="LoginUser_Authenticate">
        <LayoutTemplate>
			<div class="pure-g">
				<div class="pure-u-1 pure-u-sm-18-24 pure-u-lg-12-24">
					<div class="form form-register">
						<div class="form-space">
							<h2 class="form-head">Log In</h2>
							<div class="form-line">
                                <div id="failuretextdiv" visible="false" class="error"  runat="server">
                                    <asp:Literal ID="FailureText" runat="server"></asp:Literal>
                                </div>
                                <asp:ValidationSummary ID="LoginUserValidationSummary" runat="server" CssClass="error" />

								<label class="form-label" for="UserName">Username or Email
                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" Display="Dynamic"
                                        CssClass="requiredValidator" ErrorMessage="User Name is required." ToolTip="Email is required.">Email is required</asp:RequiredFieldValidator>
								</label>
                                <asp:TextBox runat="server" class="large" id="UserName" placeholder=""></asp:TextBox>
							</div>
							<div class="form-line">
								<label class="form-label" for="Password">Password
                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" Display="Dynamic"
                                        CssClass="requiredValidator" ErrorMessage="Password is required." ToolTip="Password is required.">Password is required</asp:RequiredFieldValidator>
								</label>
                                <asp:TextBox runat="server" class="large" id="Password" placeholder="" TextMode="Password"></asp:TextBox>
                                <asp:HyperLink ID="ForgotLink" runat="server" NavigateUrl="/Forgot" EnableViewState="false" CssClass="legend blue">Forgot your password?</asp:HyperLink>
							</div>
							<div class="form-submit">
                                <asp:Button runat="server" CssClass="button button-large" ID="btnLogin" CommandName="Login" Text="Log In" OnClick="btnLogin_Click" />
							</div>
						</div>

						<p class="form-important">
							<strong>Important:</strong> We are strictly an online dating website. Do not use this website to promote or seek out Escort services. Any and all commercial or illegal activities are prohibited. Members who engage in such activities or violate our “no escort” policy will be permanently banned from our website.
						</p>
					</div>
				</div>
			</div>
        </LayoutTemplate>
    </asp:Login>
</asp:Content>
