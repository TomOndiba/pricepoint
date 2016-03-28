<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" ViewStateMode ="Disabled" AutoEventWireup="true" CodeFile="EditProfile.aspx.cs" Inherits="RegistrationTest" %>

<%@ Register Src ="~/Account/RegistrationCtrl.ascx" TagPrefix="uc" TagName="UserRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc:UserRegistration runat="server" ID ="ucUserRegistration"/>
    
</asp:Content>

