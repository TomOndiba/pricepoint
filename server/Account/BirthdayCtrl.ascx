<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BirthdayCtrl.ascx.cs" Inherits="Account_BirthdayCtrl" %>

<div class="form-line">
	<label for="birthday">Birthday</label>
	<div class="select-large select-date">
        <asp:DropDownList CssClass="select" runat="server" ID="ddlMonth" ></asp:DropDownList>
        <asp:DropDownList CssClass="select" runat="server" ID="ddlDay"></asp:DropDownList>
        <asp:DropDownList CssClass="select" runat="server" ID="ddlYear"></asp:DropDownList>
	</div>
</div>