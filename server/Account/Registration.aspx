<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" ViewStateMode ="Disabled" AutoEventWireup="true" CodeFile="Registration.aspx.cs" Inherits="Registration" %>

<%@ Register Src ="~/Account/RegistrationCtrl.ascx" TagPrefix="uc" TagName="UserRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc:UserRegistration runat="server" ID ="ucUserRegistration" IsRegistration="true"/>
    
</asp:Content>

