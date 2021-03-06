﻿<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" ViewStateMode="Disabled" EnableViewState="false" EnableEventValidation="false" AutoEventWireup="true" CodeFile="Settings.aspx.cs" Inherits="Account_Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
	<div class="pure-g">
		<div class="pure-u-1 pure-u-sm-14-24 pure-u-lg-11-24">
			<div class="form form-register">
				<div class="form-space">
					<h2 class="form-head">Settings</h2>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="error" />
                        <section class="info">
                            <h2 class="title">Update Email or Password</h2>
                            <div class="form-line">
								<label for="txtPassword">New Password
<%--                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" 
                                            CssClass="requiredValidator" ErrorMessage="Password is required." ToolTip="Password is required.">*</asp:RequiredFieldValidator>--%>
                                <asp:RegularExpressionValidator Display = "None" ControlToValidate = "txtPassword" ID="RegularExpressionValidator2" 
                                    ValidationExpression = "^[\s\S]{6,}$" runat="server" ErrorMessage="Minimum 6 characters required for password."></asp:RegularExpressionValidator>
								</label>
                                <asp:TextBox CssClass="large" id="txtPassword" runat="server" TextMode="Password" placeholder="" />
                            </div>
                            <div class="form-line">
								<label for="txtPassword2">Confirm Password
<%--                                <asp:RequiredFieldValidator ID="rfvPassword2" runat="server" ControlToValidate="txtPassword2" 
                                            CssClass="requiredValidator" ErrorMessage="Password is required." ToolTip="Password is required.">*</asp:RequiredFieldValidator>--%>
                                <asp:CompareValidator ID="cvPassword2" runat="server" ControlToValidate="txtPassword2" ControlToCompare="txtPassword" ErrorMessage="Password must be the same" 
                                    ToolTip="Password must be the same" CssClass="requiredValidator">No match</asp:CompareValidator>
								</label>
                                <asp:TextBox CssClass="large" id="txtPassword2" runat="server" TextMode="Password"  placeholder="" />
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
                        </section>

                    <section>
                        <h2 class="title">Email Notifications</h2>
                        <div class="form-line form-line-checkbox">
                            <asp:CheckBox runat="server" ID ="cbxEmailNewMatches" class="css-checkbox" Text ="Email my most recent matches."></asp:CheckBox>
                        </div>
                        <div class="form-line form-line-checkbox">
                            <asp:CheckBox runat="server" ID ="cbxEmailWhenNewMessage" class="css-checkbox" Text ="Let me know when I receive a new message."></asp:CheckBox>
                        </div>
                        <div class="form-line form-line-checkbox">
                            <asp:CheckBox runat="server" ID ="cbxEmailWhenFavorited" class="css-checkbox" Text ="Let me know when someone favorites me."></asp:CheckBox>
                        </div>
                        <div class="form-line form-line-checkbox">
                            <asp:CheckBox runat="server" ID ="cbxemail_when_new_offer" class="css-checkbox" Text ="Let me know when someone sends me an offer."></asp:CheckBox>
                        </div>
                        <div class="form-line form-line-checkbox">
                            <asp:CheckBox runat="server" ID ="cbxEmailNewsletter" class="css-checkbox" Text ="Email me a newsletter."></asp:CheckBox>
                        </div>
                    </section>
                    <section>
                        <h2 class="title">Privacy</h2>
                        <div class="form-line form-line-checkbox">
                            <asp:CheckBox runat="server" ID ="cbxHideFromSearchResults" class="css-checkbox" Text ="Hide me from search results."></asp:CheckBox>
                        </div>
                        <!--div class="form-line form-line-checkbox">
                            <asp:CheckBox runat="server" ID ="cbxHideOnViewedFavoritedList" class="css-checkbox" Text ="Will not show in other user`s favorite list."></asp:CheckBox>
                        </div>
                        <div class="form-line form-line-checkbox">
                            <asp:CheckBox runat="server" ID ="cbxHideLastLogintime" class="css-checkbox" Text ="Hide my last login date & time."></asp:CheckBox>
                        </div-->
                    </section>

					<div class="form-submit">
                        <asp:Button runat="server" ID="btnUpdate" CssClass="button button-large button-sign" Text="Update My Settings" OnClick="btnUpdate_Click" />
					</div>


                        <h2 class="title" style="color:silver">Cancel Account</h2>
                        <div class="form-line form-line-checkbox">
                        <asp:Button runat="server" ID="Button_CANCEL_SUB" CssClass="button button-gray" style="margin-bottom:15px"  width="195px" Text="Cancel Paid Subscription" OnClientClick="return confirm('Are you sure you want to cancel your subscription?')===true" OnClick="Button2_Click" />
                            <asp:Label ID="PAID" runat="server" Visible="false"></asp:Label>
                        <asp:Button runat="server" ID="Button1" CssClass="button button-gray" width="195px" Text="Cancel My Account" OnClientClick="return confirm('Are you sure you want to cancel your account?')===true" OnClick="Button1_Click" />
                        </div>

				</div>
    		</div>
		</div>
        </div>
</asp:Content>