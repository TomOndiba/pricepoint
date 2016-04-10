<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="UpdateBilling.aspx.cs" Inherits="Account_UpdateBilling" %>

<%@ Register Src="~/Account/CreditCardForm.ascx" TagPrefix="uc1" TagName="CreditCardForm" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="beforeform" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <p class="heading" runat="server" id="heading"><asp:Label ID="lblResult" runat="server" ></asp:Label></p>

<asp:PlaceHolder runat="server" ID="mainsection">
    <div class="form-order">
        <h2>Update Your Credit Card</h2>
    <div class="space">
    <div class="pure-g">
    <div class="pure-u-1 pure-u-md-12-24">

    <uc1:CreditCardForm runat="server" ID="CreditCardForm" />
    								<p class="form-submit" style="margin-top:15px">
									<asp:Button ID="btnSubmit" runat="server" class="button" Text="Update Credit Card" OnClick="btnSubmit_Click"  />
                                    <input type="button" value="Submitting..." class="button" id="btnFake" disabled="true"  style="display: none"/>
								</p>
        <p>We do not store billing information on our servers. It is available only to Authorize.net which is a leading payment processor complient with the latest PCI security standards. Your information is secure.</p>
</div>
        </div>
        </div></div>
</asp:PlaceHolder>

<script type="text/javascript">
    $('.selectric').selectric({
        maxHeight: 400,
        disableOnMobile: false,
        responsive: true
    });

</script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="bottom" Runat="Server">
</asp:Content>

