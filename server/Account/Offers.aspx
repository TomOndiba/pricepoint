<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Offers.aspx.cs" Inherits="Account_Offers" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


<ul class="links-group" runat="server" id="offermenu">
				<li><a <%=MyUtils.MenuLink("/Account/Offers.aspx?type=New")%> ><span class="icon icon-new"></span> New <span class="mobile-hidden">Offers <%=NewOffers%></span> </a></li>
				<li><a <%=MyUtils.MenuLink("/Account/Offers.aspx?type=Accepted")%> ><span class="icon icon-tick"></span> Accepted <span class="mobile-hidden">Offers <%=Accepted%></span> </a></li>
				<li runat="server" id="winksmenu" ><a <%=MyUtils.MenuLink("/Account/Offers.aspx?type=Wink")%> ><span class="icon icon-wink"></span> Winks <span class="mobile-hidden"><%=Winks%></span> </a></li>
				<li runat="server" id="pendingmenu" ><a <%=MyUtils.MenuLink("/Account/Offers.aspx?type=Pending")%> ><span class="icon icon-sandglass"></span> Pending <span class="mobile-hidden">Offers <%=Pending%></span> </a></li>
				<li><a <%=MyUtils.MenuLink("/Account/Offers.aspx?type=Rejected")%> ><span class="icon icon-sandglass"></span> Rejected <span class="mobile-hidden">Offers <%=Rejected%></span> </a></li>
</ul>

<!-- Offers -->
<section class="offers">
<div class="pure-g">
                        <asp:Repeater ID="Repeater1" runat="server">
        <ItemTemplate>


					<div class="pure-u-1 pure-u-sm-12-24 pure-u-lg-8-24">
						<div class="panel panel-<%# Eval("type").ToString().ToLower() %>" data-id_offer="<%# Eval("id_offer") %>" data-id="<%# Eval("id_user") %>" data-user="<%# Eval("username") %>">
							<p class="head"><%# Eval("type") %>
								<time class="date" datetime="<%#Convert.ToDateTime(Eval("time")).ToString("yyyy/MM/dd")%>"><%#Convert.ToDateTime(Eval("time")).ToString("MM/dd/yy")%></time>
								<img class="icon" src="" alt="">
							</p>
							<div class="panel-space">
								<div class="info">
									<a class="photo" href="/Account/ViewProfile.aspx?id=<%# Eval("id_user") %> "><img src="<%# MyUtils.GetImageUrl(Eval("MainPhoto"),MyUtils.ImageSize.TINY) %>" width="100" height="100" alt=""></a>
									<p class="name"><%# Eval("username") %> <span class="small"></span></p>
									<p class="location"><%# Eval("age") %> / <%# Eval("place") %></p>
									<p class="type"><%# Convert.ToDouble(Eval("Amount")).ToString("f0")=="0" ? "Wink" : Convert.ToDouble(Eval("Amount")).ToString("C0")%></p>
								</div>



								<div runat="server" class="buttons" visible='<%# Eval("type").ToString().ToLower()=="wink" %>' >
									<div class="cell"><a class="button js-popup" href="popup-offer.html">Make Offer</a></div>
									<div class="cell"><a class="button button-black js-reject-offer" href="#">Reject</a></div>
								</div>



								<div runat="server" class="buttons" visible='<%# Eval("type").ToString().ToLower()=="rejected" %>' >
									<div class="cell"><a class="button js-popup" href="popup-offer.html">Make New Offer</a></div>
									<div class="cell"><p class="text js-reject-offer"><span class="h">Reason</span> Not interested</p></div>
								</div>



                                <div runat="server" class="buttons show-new" visible='<%# Eval("type").ToString().ToLower()=="new" || Eval("type").ToString().ToLower()=="countered" %>'>
									<div class="cell"><a class="button js-accept-offer" href="#">Accept</a></div>
									<div class="cell"><a class="button button-blue js-popup" href="popup-offer.html" data-counter="1">Counter</a></div>
									<div class="cell"><a class="button button-black js-reject-offer" href="#">Reject</a></div>
								</div>


                                <div runat="server" class="buttons" visible='<%# Eval("type").ToString().ToLower()=="pending" %>'>
									<div class="cell"><a class="button button-black js-withdraw-offer" href="#">Withdraw Offer</a></div>
								</div>


                               <div runat="server" class="buttons show-accepted" visible='<%# Eval("type").ToString().ToLower()=="accepted" %>'>
<div class="cell">
<asp:Button ID="but"  class="button" Text='<%#"Unlock for "+ Eval("credits") +" credits"%>' CommandArgument='<%#Eval("id_offer") %>' runat="server" Visible='<%# Eval("locked").ToString()=="Locked" && MyUtils.IsMale %>' OnClick="but_Click"></asp:Button>
<asp:Button ID="Button1"  class="button" Text='Send Message' runat="server" CommandArgument='<%#Eval("id_offer") %>' Visible='<%# Eval("locked").ToString()=="Unlocked" || MyUtils.IsFemale %>' OnClick="but_Click"></asp:Button>
</div>
								</div>


							</div>
						</div>
					</div>


        </ItemTemplate>
    </asp:Repeater>
        <asp:Label runat="server" ID="empty"></asp:Label>

</div>
</section>
<!-- /Offers -->

</asp:Content>

