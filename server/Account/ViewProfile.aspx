<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" ViewStateMode="Disabled" EnableEventValidation="false" AutoEventWireup="true" CodeFile="ViewProfile.aspx.cs" Inherits="Account_ViewProfile" %>

<%@ Register Src="~/Account/UserPersonnalData.ascx" TagPrefix="uc" TagName="UserPersonnalData" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

	<div class="info" runat="server">
		<asp:Label runat="server" ID="lblMessage"></asp:Label>
	</div>

	<!-- Container -->
	<main class="container">
		<div class="wrapper" >

			<section>
				<!-- Profile -->
				<div class="profile" data-id="<%=userRow["id_user"].ToString()%>" data-id_offer="<%=userRow["id_offer_state"].ToString()%>" data-user="<%=userRow["username"].ToString()%>">
					<div class="photo my-gallery" data-gallery="1" itemscope itemtype="http://schema.org/ImageGallery">
						<figure itemprop="associatedMedia" style="position:relative" itemscope itemtype="http://schema.org/ImageObject">
							<a href='<%=MyUtils.GetImageUrl(userRow, MyUtils.ImageSize.ORIGINAL_SIZE)%>' itemprop="contentUrl" data-size='<%=GetImageSize(userRow) %>'>
								<img src='<%=MyUtils.GetImageUrl(userRow, MyUtils.ImageSize.MEDIUM)%>' width="160" height="160" alt="">
								<div id="isonline" runat="server" class="rib-wrapper"><div class="rib">Online</div></div>
								<span class="vip">VIP</span>
								<span runat="server" id="agreedprice" visible="false" class="agreedprice">$350</span>
							</a>
						</figure>
					</div>
					<!-- Inform -->
					<div class="inform">
						<div class="text">
							<h2 class="name">
								<asp:Literal runat="server" ID="ltUserName" />
								<asp:Label Visible="false" runat="server" ID="lblGender" CssClass="small" /></h2>
							<p class="activity">
								<asp:Literal runat="server" ID="ltActivity" />
							</p>
							<p class="location" style="margin-top:4px">
								<asp:Literal runat="server" ID="ltAge" /> * <asp:Literal runat="server" ID="ltLocation" /><span class="range"><asp:Literal runat="server" ID="ltDistance" /> miles</span>
								
							</p>
							<p class="status">
								<asp:Literal runat="server" ID="ltStatus" />
							</p>
						</div>
						<div class="actions">
							<!-- Not done yet -->
							<ul class="list" runat="server" id="lActions">

<!--"<a "+Utils.Hide("offer",userRow["id_offer_state"])+" class='button button-icon js-popup' href='popup-offer.html'><span class='icon icon-offer'></span> Send Offer</a><span  "+Utils.Hide("offersent",userRow["id_offer_state"])+" class='cell'>Offer Sent</span><a "+Utils.Hide("message",userRow["id_offer_state"])+" class='button button-blue button-icon js-popup' href='#popup-message'><span class='icon icon-message'></span> Send Message</a>"-->
<style type="text/css">
.view_offer
{	min-width: 150px;
	margin: 0;
	padding: 4px;
	display: inline-block;
	cursor: default;
	font-size: 30px;
	line-height: 24px;
	text-align: center;
	color: #4c9eda;
	font-weight: bold;
	background: #fff;
	border: 1px solid #e5e5e5;
	border-radius: 2px;
	}
</style>
<li>
<div id="DIV_ACCEPTCOUNTERREJECT" visible="false" runat="server" class="buttons show-new">
<span class="cell"><a class="button js-accept-offer" href="#">Accept <%=accepttext%></a></span>
<span class="cell"><a class="button button-blue js-popup" href="popup-offer.html" data-counter="1">Counter</a></span>
<span class="cell"><a class="button button-black js-popup" href="popup-reject.html">Reject</a></span>
</div>
<a id="BUT_SENDOFFER" visible="false" runat="server" class='button button-icon js-popup sendofferbutton' href='popup-offer.html'><span class='icon icon-offer'></span> <%=MyUtils.IsFemale ? "Name Your Price":"Send Offer" %></a>
<a id="OfferText" runat="server" class='button button-icon sendofferbuttonDONE' style="display:none;background-color:#00cb50;color:white;cursor:default;border:1px solid #00ab30" href='#'>Offer was sent</a>
<a id="BUT_SENDMESSAGE" visible="false" runat="server"  class='button button-blue button-icon' href=''><span class='icon icon-message'></span> [SEND MESSAGE]</a>
</li>
<script>
function MakeOfferDone(panel,amount)
{
	$('.sendofferbutton').hide();
	$('.sendofferbuttonDONE').html('$'+amount+' offer was sent');
	$('.sendofferbuttonDONE').show();

}
</script>

								<li class="hf">
								<span class="col"><a class="button button-gray button-icon js-favorite <%= userRow["favorite"].ToString()=="1" ? "active" : "" %>" href="#favorite"><span class="icon icon-fav"></span> Favorite</a></span>
								<span class="col"><%=MyUtils.ShowIfLogedinUserField("sex","F","<a class='button button-gray button-icon js-wink "+(userRow["wink"].ToString()=="1"?"active":"")+"' href='#wink'> <span class='icon icon-wink'></span> <span class='sendwink'>Send Wink</span><span class='sentwink'>Wink Sent</span></a>") %></span>
								</li>
							</ul>
							<!-- Report -->
							<div class="report" runat="server" id="divReport">
								<asp:LinkButton runat="server" ID="btEdit" CssClass="button button-white" Text="Edit" Visible="false"/>
								<asp:LinkButton runat="server" ID="btnBan" CssClass="button button-white" OnClick="btnBan_Click" Text="Ban" Visible="false"/>
								<asp:LinkButton runat="server" ID="btnBlock" CssClass="button button-white" OnClick="btnBlock_Click" Text="Block" />
								<a class="button js-popup button-white" href="#report-message">Report </a>
							</div>
						</div>
					</div>
				</div>
				<!-- /Profile -->

				<!-- Sidebar -->
				<section class="sidebar">
					<uc:UserPersonnalData runat="server" ID="userPersData" dlClass="description" />
				</section>
				<!-- /Sidebar -->

				<!-- Content -->
				<div class="content">
					<ul class="tabs">
						<li class="active"><a href="#about"><span class="icon icon-about"></span>About Me</a></li>
						<li runat="server" id="liHistory">
							<a href="#history" onclick="__doPostBack('upHistory','')"><span class="icon icon-history"></span>Our History</a></li>
					</ul>
					<section id="about" class="tab">
						<h3 class="hidden">About Me</h3>
						<p><asp:Literal runat="server" ID="ltAbout" /></p>
						<p class="h6">My First Date Expectations:</p>
						<p><asp:Literal runat="server" ID="ltFirstDate" /></p>
						<section class="gallery">
							<h6 class="heading"><a href="#">Photos (<asp:Literal runat="server" ID="ltPhotosCount" />)</a></h6>
							<div class="my-gallery" data-gallery="1" itemscope itemtype="http://schema.org/ImageGallery">
								<asp:Repeater ID="Repeater1" runat="server">
									<ItemTemplate>
										<figure itemprop="associatedMedia" itemscope itemtype="http://schema.org/ImageObject">
											<a href='<%#MyUtils.GetImageUrl(Eval("SecondaryPhoto"),MyUtils.ImageSize.ORIGINAL_SIZE)%>' itemprop="contentUrl" data-size='<%#Eval("ImageSize")%>'>
												<img src='<%#MyUtils.GetImageUrl(Eval("SecondaryPhoto"),MyUtils.ImageSize.SMALL)%>' width="132" height="132" alt="" />
											</a>
										</figure>
									</ItemTemplate>
								</asp:Repeater>
							</div>
						</section>
						<uc:UserPersonnalData runat="server" ID="userPersDataForMobiles" dlClass="mobile-visible" />
						<uc:UserPersonnalData runat="server" ID="userPersDataExtention" />
						<div class="gifts" id="gifts" runat="server">
							<p class="heading"><a href="#">Gifts</a></p>
							<ul>
								<asp:Repeater ID="rpGifts" runat="server">
									<ItemTemplate>
										<li><img src='/img/gifts/<%#Container.DataItem.ToString()%>.jpg' height="50" alt="" /></li>
									</ItemTemplate>
								</asp:Repeater>
							</ul>
						</div>
					</section>
					<section id="history" class="tab tab-hidden">
						<asp:UpdatePanel runat="server" ID="upHistory" OnLoad="upHistory_Load" ClientIDMode ="Static">
							<ContentTemplate>
							<p><asp:Literal runat="server" ID="ltNoHistory" Text="You don't have any history yet, start by sending an offer." Visible="false" /></p>
							<div runat="server" id="divHistory">
								<p><asp:Label runat="server" ID="lblHistory" /></p>
							</div>
							</ContentTemplate>
						</asp:UpdatePanel>
					</section>
					<div runat="server" id="divMobileReport" class="buttons-group mobile-visible">
						<p class="cell"><asp:LinkButton runat="server" ID="btnBanMobile" CssClass="button button-white" OnClick="btnBan_Click" Text="Ban" Visible="false"/></p>
						<p class="cell"><asp:LinkButton runat="server" ID="btnMobileBlock" CssClass="button button-white" OnClientClick="javascript: return confirm('Are you sure you want to block this user?');" OnClick="btnBlock_Click" Text="Block" /></p>
						<p class="cell"><a class="button js-popup button-white" href="#report-message">Report</a></p>
					</div>
				</div>
				<!-- /Content -->

			</section>
		</div>
	</main>
	<!-- /Container -->



	<!-- Message popup -->
	<div id="popup-message" class="popup popup-message mfp-hide">
		<h2 class="h2 heading">Send a First Date Offer to <span class="color">Jemma21</span></h2>

		<div class="form-line form-line-radiobox">
			<label class="radiobox radiobox-price">
				<input name="sum" type="radio" value="50">
				&#36;50</label>
			<label class="radiobox radiobox-price">
				<input name="sum" type="radio" value="100">
				&#36;100</label>
			<label class="radiobox radiobox-price">
				<input name="sum" type="radio" value="150">
				&#36;150</label>
			<label class="radiobox radiobox-price">
				<input name="sum" type="radio" value="200">
				&#36;200</label>
			<label class="radiobox radiobox-price">
				<input name="sum" type="radio" value="300">
				&#36;300</label>
		</div>
		<div class="presents">
			<p class="head">Impress Her by Sending a Virtual Gift for Only 5 Credits</p>
			<div class="list">
				<div class="cell">
					<label class="checkbox checkbox-gift">
						<input type="checkbox" value="flowers">
						<img src="../img/gifts/1-(90x90).png" width="90" alt="">
					</label>
					&nbsp;
				</div>
				<div class="cell">
					<label class="checkbox checkbox-gift">
						<input type="checkbox" value="box">
						<img src="../img/gifts/2-(90x90).png" width="90" alt="">
					</label>
					&nbsp;
				</div>
				<div class="cell">
					<label class="checkbox checkbox-gift">
						<input type="checkbox" value="toy">
						<img src="../img/gifts/3-(90x90).png" width="90" alt="">
					</label>
					&nbsp;
				</div>
				<div class="cell">
					<label class="checkbox checkbox-gift">
						<input type="checkbox" value="bag">
						<img src="../img/gifts/4-(90x90).png" width="90" alt="">
					</label>
					&nbsp;
				</div>
				<div class="cell">
					<label class="checkbox checkbox-gift">
						<input type="checkbox" value="shoes">
						<img src="../img/gifts/5-(90x90).png" width="90" alt="">
					</label>
					&nbsp;
				</div>
				<div class="cell">
					<label class="checkbox checkbox-gift">
						<input type="checkbox" value="drink">
						<img src="../img/gifts/6-(90x90).png" width="90" alt="">
					</label>
					&nbsp;
				</div>
			</div>
		</div>
		<div class="form-submit">
			<label>
				or Type a Custom Amount
					<input class="total" type="text" value=""></label>
			<input class="button" type="submit" value="Send Offer">
		</div>

	</div>
	<!-- /Message popup -->

	<div id="report-message" class="popup mfp-hide">
		<h2 class="h2 heading">Please describe in detail the issue you have with this user.</h2>
		<div class="form-submit">
			<asp:TextBox TextMode="MultiLine" runat="server" ID="tbReportText" CssClass="total" Columns="70" Rows="10" />
			<br />
			<asp:Button runat="server" ID="btnReportSubmit" CssClass="button" Text="Send Report" OnClick="btnReportSubmit_Click" />
		</div>
	</div>

	<!-- Photoswipe popup -->
	<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">
		<!-- Background of PhotoSwipe.
			 It's a separate element, as animating opacity is faster than rgba(). -->
		<div class="pswp__bg"></div>
		<!-- Slides wrapper with overflow:hidden. -->
		<div class="pswp__scroll-wrap">
			<!-- Container that holds slides. PhotoSwipe keeps only 3 slides in DOM to save memory. -->
			<!-- don't modify these 3 pswp__item elements, data is added later on. -->
			<div class="pswp__container">
				<div class="pswp__item"></div>
				<div class="pswp__item"></div>
				<div class="pswp__item"></div>
			</div>
			<!-- Default (PhotoSwipeUI_Default) interface on top of sliding area. Can be changed. -->
			<div class="pswp__ui pswp__ui--hidden">
				<div class="pswp__top-bar">
					<!--  Controls are self-explanatory. Order can be changed. -->
					<div class="pswp__counter"></div>
					<span class="pswp__button pswp__button--close" title="Close (Esc)"></span>
					<span class="pswp__button pswp__button--zoom" title="Zoom in/out"></span>
					<!-- Preloader demo http://codepen.io/dimsemenov/pen/yyBWoR -->
					<!-- element will get class pswp__preloader--active when preloader is running -->
					<div class="pswp__preloader">
						<div class="pswp__preloader__icn">
							<div class="pswp__preloader__cut">
								<div class="pswp__preloader__donut"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
					<div class="pswp__share-tooltip"></div>
				</div>
				<span class="pswp__button pswp__button--arrow--left" title="Previous (arrow left)">
				</span>
				<span class="pswp__button pswp__button--arrow--right" title="Next (arrow right)">
				</span>
				<div class="pswp__caption">
					<div class="pswp__caption__center"></div>
				</div>
			</div>
		</div>
	</div>
	<!-- /Photoswipe popup -->

	<script type="text/javascript">
		Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () { $("img[src='/img/loading.gif']").remove(); });
	</script>

	<!-- <%=sql %> -->
</asp:Content>

