<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Forgot.aspx.cs" Inherits="Forgot" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2 style="margin-top: -5px;">
        Forgot Your Password?
    </h2>

    <asp:Panel ID="panelSuccess" CssClass="success" runat="server" Visible="False">
        <asp:Label ID="labelSuccess" runat="server" Text="Label">Success</asp:Label>
    </asp:Panel>

    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="error" />

    <div style="width:378px;padding-top:30px">
        Enter your registered e-mail to receive your password:<br/><br/>
        <asp:TextBox ID="txtEmail" runat="server" ></asp:TextBox>
        <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="txtEmail" Display="Dynamic"
            CssClass="requiredValidator" ErrorMessage="Email is required." ToolTip="Email is required.">Email is required</asp:RequiredFieldValidator>
        <br/><br/>
        <asp:Button ID="btnsend" CssClass="mybutton" style="float: left" runat="server" Text="Send" onclick="btnsend_Click" />
    </div>
</asp:Content>
