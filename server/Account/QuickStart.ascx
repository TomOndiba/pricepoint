<%@ Control EnableViewState="false" Language="C#" AutoEventWireup="true" CodeFile="QuickStart.ascx.cs" Inherits="Account_QuickStart" %>


<div class="text" id="his" runat="server"> 
<p><b><%=Title%></b> Start by making a search to find women that you like. Then click on <i>Send Offer</i> button to ask them for a date. Once they agree on the price you'll get notified by email and you will be able to unlock messaging to set up a date to meet in person. The more offers you send out the more dates you'll get.<br />
<a href="/Account/Search" style="margin-top:14px" class="button">Click Here to Search</a>
</div>

<div class="text" id="her" runat="server">
<p><b><%=Title%></b> Start by clicking on the Search button to find men that you like. Then click on the <i>Wink</i> or <i>Name My Price</i> button to let him know you're interested. Once he sends you an offer or accepts your price you'll get notified by email and you will be able to send messages to set up a date to meet in person.<br />
<a href="/Account/Search" style="margin-top:14px" class="button">Click Here to Search</a>
</div>

