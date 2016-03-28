<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="VerifyEmail.aspx.cs" Inherits="Account_VerifyEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="beforeform" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

                    						<!-- Attention -->
                <div style="max-width:350px">
						<div class="attention" id="VerifiedBox" runat="server">
							<p class="alert"><img src="/img/icons/attention.png" alt=""></p>
							<div class="text">
								<p>Please activate your account. Check your inbox for our verification email and click on the link inside.</p>
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ValidationGroup="subscribe" EnableClientScript="false" Enabled="true"
                                            CssClass="requiredValidator" ErrorMessage="Email Address is required." ToolTip="Email Address is required.">Email Address is required</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ValidationExpression="^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$"  Display="Dynamic" 
                                        CssClass="requiredValidator" ControlToValidate="txtEmail" ValidationGroup="subscribe"  ErrorMessage="Invalid Email Format">Invalid Email Format</asp:RegularExpressionValidator>

								<div class="form-subscribe">
									<label for="email"></label>

                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtEmail" Display="Dynamic"
                                            CssClass="requiredValidator" ErrorMessage="Email Address is required." ToolTip="Email Address is required.">Email Address is required</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ValidationExpression="^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$"  Display="Dynamic"
                                        CssClass="requiredValidator" ControlToValidate="txtEmail"  ErrorMessage="Invalid Email Format">Invalid Email Format</asp:RegularExpressionValidator>

									<asp:TextBox ID="txtEmail" runat="server" placeholder="" type="email" ValidationGroup="subscribe"></asp:TextBox>
									<asp:Button id="btnSendCode" runat="server"  Text="Resend Verification Code" CssClass="button button-black" OnClick="btnSendCode_Click" ValidationGroup="subscribe" />
								</div>
							</div>
						</div>
                    </div>
						<!-- /Attention -->

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="bottom" Runat="Server">
</asp:Content>

