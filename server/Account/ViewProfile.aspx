<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" ViewStateMode="Disabled" EnableEventValidation="false" AutoEventWireup="true" CodeFile="ViewProfile.aspx.cs" Inherits="Account_ViewProfile" %>

<%@ Register Src="~/Account/UserPersonnalData.ascx" TagPrefix="uc" TagName="UserPersonnalData" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="info" runat="server">
        <asp:Label runat="server" ID="lblMessage"></asp:Label>
    </div>

    <h2 runat="server" visible="false" id="h2deleted"></h2>    
    
    <!-- Container -->
    <main class="container" runat="server" id="maincontainer">
        <div class="wrapper" >

            <section>
                <!-- Profile -->
				<div class="profile item" data-id="<%=userRow["id_user"].ToString()%>" data-id_offer="<%=userRow["ID_OFFER_REAL"].ToString()%>" data-user="<%=userRow["username"].ToString()%>">
                    <div class="photo my-gallery" data-gallery="1" itemscope itemtype="http://schema.org/ImageGallery">
                        <figure itemprop="associatedMedia" style="position:relative" itemscope itemtype="http://schema.org/ImageObject">
                            <a href='<%=MyUtils.GetImageUrl(userRow, MyUtils.ImageSize.ORIGINAL_SIZE)%>' itemprop="contentUrl" data-size='<%=GetImageSize(userRow) %>'>
                                <img src='<%=MyUtils.GetImageUrl(userRow, MyUtils.ImageSize.MEDIUM)%>' width="160" height="160" alt="" />
<div id="isonline" runat="server" class="rib-wrapper"><div class="rib">Online</div></div>
								<%=userRow["VIP"].ToString()=="Y"?"<span class='vip'>VIP</span>":""%> 
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
                        <div class="actions" data-id="<%=userRow["id_user"].ToString()%>"  data-id_offer="<%=userRow["ID_OFFER_REAL"].ToString()%>"  data-user="<%=userRow["username"].ToString()%>">
                            <ul class="list" runat="server" id="lActions">

<style type="text/css">
.view_offer
{    min-width: 150px;
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
<li class="hf">
<div id="DIV_ACCEPTCOUNTERREJECT" visible="false" runat="server" class="buttons show-new">
<span class="cell"><a class="button js-accept-offer" href="#">Accept <%=accepttext%></a></span>
<span class="cell"><a class="button button-blue js-popup" href="popup-offer.aspx" data-counter="1">Counter</a></span>
<span class="cell"><a class="button button-black js-popup" href="popup-reject.aspx">Reject</a></span>
</div>
</li>
<script>
function MakeOfferDone(panel,amount) {
    $('.sendofferbutton').hide();
    $('.sendofferbuttonDONE').html('You sent $'+amount+' offer');
    $('.sendofferbuttonDONE').show();
}
</script>

								<li class="hf">
									<span class="col <%=userRow["sex"].ToString()=="M" ? "col-full" :""%>"><a id="OfferText" runat="server" class='button button-icon sendofferbuttonDONE SW_OFFERSENT' style="display:none" href='#'>Offer was sent</a></span>
									<span class="col <%=userRow["sex"].ToString()=="M" ? "col-full" :""%>"><a id="BUT_SENDOFFER" visible="false" runat="server" class='button button-icon js-popup sendofferbutton' href="popup-offer.aspx"><span class='icon icon-offer'></span> <%=SendOfferText %></a></span>
									<span class="col <%=userRow["sex"].ToString()=="M" ? "col-full" :""%>"><a id="BUT_SENDMESSAGE" visible="false" runat="server"  class='button button-blue button-icon' href=''><span class='icon icon-message'></span> [SEND MESSAGE]</a></span>
									<span class="col"><a class="button button-gray button-icon js-favorite <%= userRow["favorite"].ToString()=="1" ? "active" : "" %>" href="#favorite"><span class="icon icon-fav"></span> Favorite</a></span>
									<span class="col"><%=MyUtils.ShowIfLogedinUserField("sex","F","<a class='button button-gray button-icon js-wink "+(userRow["wink"].ToString()=="1"?"active":"")+"' href='#wink'> <span class='icon icon-wink'></span> <span class='sendwink'>Send Wink</span><span class='sentwink'>Wink Sent</span></a>") %></span>
								</li>
							</ul>
                            <!-- Report -->
                            <div class="report" runat="server" id="divReport">
                                <asp:LinkButton runat="server" ID="btEdit" CssClass="button button-white" Text="Edit" Visible="false"/>
                                <asp:LinkButton runat="server" ID="btnBan" CssClass="button button-white" OnClick="btnBan_Click" Text="Ban" Visible="false"/>
                                <asp:LinkButton runat="server" ID="btnBlock" CssClass="button button-white" OnClick="btnBlock_Click" Text="Block" />
                                <a class="button js-popup-inline button-white" href="#report-message">Report </a>
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
                        <p>
                            <asp:Literal runat="server" ID="ltAbout" />
                        </p>
                        <p class="h6">My First Date Expectations:</p>
                        <p>
                            <asp:Literal runat="server" ID="ltFirstDate" />
                        </p>

                        <section class="gallery">
                            <h6 class="heading" runat="server" id="photoslabel"><a href="#" class="notclickable" onclick="return false;">Photos (<asp:Literal runat="server" ID="ltPhotosCount" />)</a></h6>
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
                            <p class="heading"><a href="#" class="notclickable" onclick="return false;">Gifts</a></p>
                            <ul>
                                <asp:Repeater ID="rpGifts" runat="server">
                                    <ItemTemplate>
                                        <li>
                                            <img src='/img/gifts/<%#Container.DataItem.ToString()%>.jpg' height="50" alt="" /></li>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                        </div>
                    </section>
                    <section id="history" class="tab tab-hidden">
                        <asp:UpdatePanel runat="server" ID="upHistory" OnLoad="upHistory_Load" ClientIDMode ="Static">
                            <ContentTemplate>
                            <p>
                                <asp:Literal runat="server" ID="ltNoHistory" Text="You don't have any history yet, start by sending an offer." Visible="false" />
                            </p>

                            <div runat="server" id="divHistory">
                                <p>
                                    <asp:Label runat="server" ID="lblHistory" />
                                </p>
                            </div>

                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </section>
                    <div runat="server" id="divMobileReport" class="buttons-group mobile-visible">
                        <p class="cell">
                            <asp:LinkButton runat="server" ID="btnBanMobile" CssClass="button button-white" OnClick="btnBan_Click" Text="Ban" Visible="false"/>
                        </p>
                        <p class="cell">
                            <asp:LinkButton runat="server" ID="btnMobileBlock" CssClass="button button-white" OnClick="btnBlock_Click" Text="Block" />
                        </p>
                        <p class="cell">
                            <a class="button js-popup-inline button-white" href="#report-message">Report</a>
                        </p>
                    </div>

                </div>
                <!-- /Content -->

            </section>
        </div>
    </main>
    <!-- /Container -->




<div id="report-message" class="popup mfp-hide"><h2 class="h2 heading">Please describe in detail the issue you have with this user.</h2>
<div class="form-submit"><textarea id="tbReportText" data-id_user="<%=this.currentUser%>" class="total" cols="70" rows="10" ></textarea><br />
<button id="btnReportSubmit" class="button" onclick="SendReport()">Send Report</button>
</div>
</div>


<script type="text/javascript">
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () { $("img[src='/img/loading.gif']").remove(); });
</script>        

    <!-- <%=sql %> -->
</asp:Content>

