<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserPersonnalData.ascx.cs" Inherits="UserPersonnalData" %>

<asp:Repeater runat="server" ID="rptUserData" >
    <HeaderTemplate>        
        <dl class="<%=dlClass %>"> 
    </HeaderTemplate>

    <ItemTemplate>
        <dt><%# Eval("Item1") %></dt>
        <dd><%# Eval("Item2") %></dd>
    </ItemTemplate>
        
    <FooterTemplate>
        </dl>
    </FooterTemplate>
</asp:Repeater>
