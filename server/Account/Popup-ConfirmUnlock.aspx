<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Popup-ConfirmUnlock.aspx.cs" Inherits="Account_ConfirmUnlock" %>

<div id="confirm" class="popup popup-reject" runat="server">
	<h2 class="h2 heading">Confirm Unlocking</h2>
	<form class="form-reject" action="#" method="post" data-form="reject">
		<div class="form-line item" data-id="<%=Convert.ToInt32(Request.QueryString["id"]) %>">
            Unlocking comunication with <i><b><%=user%></b></i> costs <nobr><%=cr %> credits.</nobr> Credits can not be refunded even if the member doesn't respond to your message or the date does not happen.
            <br />
            <br />
            <br />
			<button class="button" onclick="return SendMessage(this)">Yes I Agree</button>
		</div>
	</form>
</div>

<div id="nocredits" class="popup popup-reject" runat="server">
	<h2 class="h2 heading">Not Enough Credits</h2>
	<form class="form-reject" action="#" method="post" data-form="reject">
		<div class="form-line item" data-id="<%=Convert.ToInt32(Request.QueryString["id"]) %>">
            Unlocking comunication with <i><b><%=user%></b></i> costs <nobr><%=cr %> credits</nobr>. Please buy credits using our secure checkout.
            <br />
            <br />
            <br />
			<button class="button" onclick="window.location.href='/Account/Upgrade';return false;">Buy Credits</button>
		</div>
	</form>
</div>

