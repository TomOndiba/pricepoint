<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" ViewStateMode="Disabled" EnableViewState="false" EnableEventValidation="false" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Src="~/Account/QuickStart.ascx" TagPrefix="uc1" TagName="QuickStart" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <div class="info" runat="server">
          <asp:Label runat="server" ID="lblMessage"></asp:Label>
      </div>


        	<!-- Container -->
		<main class="container">
			<div class="wrapper">

				<!-- Sidebar -->
				<section class="sidebar" >

                    <!-- Recents -->
					<section class="recents">
						<h2 class="heading">Recent Activity</h2>
						<ul>
                          <asp:Repeater ID="repRecentUsersList" runat="server">
                              <ItemTemplate>
                               <li>
								    <figure class="photo"><a href='<%#GetLink(Container.DataItem)%>'><img src='<%#Eval("mainphoto")%>' width="56" height="56" alt=""></a></figure>
								    <p class="name"><a href='<%#GetLink(Container.DataItem)%>'><%# Eval("usr") %></a></p>
								    <p><%# UpdateOffer(GetDataItem()) %></p>
								    <p class="time">
									    <time><%# GetActivity(Eval("id_user"), Eval("time")) %></time>
								    </p>
							    </li>
                                </ItemTemplate>
                                </asp:Repeater>
                            <li runat="server" id="noactivity">You have no activity yet.</li>
						</ul>
					</section>
					<!-- /Recents -->

				</section>
				<!-- /Sidebar -->

				<!-- Content -->
				<div class="content content-simple">
					<div class="content-area">

						<!-- Attention -->
						<div class="attention" id="photospromo" runat="server">
							<p class="alert"><img src="/img/icons/attention.png" alt=""></p>
							<a href="/Account/UploadPhotos"><img class="avatar" style="border:solid 1px silver" src="/img/NoPhoto<%=(MyUtils.IsMale?"M":"F")%>-T.jpg" alt=""></a>
							<div class="text">
								<p><span style="color:red;font-weight:bold">ATTENTION:</span> <%=(MyUtils.IsMale?"Most":"96% of")%> <%=(MyUtils.IsMale?"women":"men")%> are <%=(MyUtils.IsMale?"responding only to":"searching only for")%> <%=(MyUtils.IsMale?"men":"women")%> with photos! Your photo is the most important part of your profile. A good quality photo will increase your chances of getting more dates by 900% <%=(MyUtils.IsMale?"You have the option to make it private.":"")%></p>
							</div>
							<div class="submit"><a class="button button-black" href="/Account/UploadPhotos">Upload Photo</a></div>
						</div>
						<!-- /Attention -->

   						<!-- Attention -->
						<div class="attention attention-blue">
							<p class="alert"><img src="/img/icons/info.png" alt=""></p>
                            <uc1:QuickStart Title="Quick Start -" runat="server" ID="QuickStart" />
						</div>
						<!-- /Attention -->


						<!-- Featured -->
						<section class="featured">
							<h2 class="head">New <%= MyUtils.IsMale ? "Women":"Men" %> <a class="link" href="/Account/Search?type=new">see more</a></h2>
							<ul>
                                 <asp:Repeater ID="repNewUsers" runat="server">
                              <ItemTemplate>
                                <li>
									<a class="area" href='<%#Utils.GetProfileLink(Container.DataItem)%>'>
										<figure class="photo"><img src='<%#MyUtils.GetImageUrl(Eval("mainphoto"),MyUtils.ImageSize.MEDIUM)%>' alt=""><%# (Eval("VIP").ToString()=="Y")?"<span class='vip'>VIP</span>":""%> </figure>
										<p class="location"><%# Eval("age")%> / <%# Eval("plc")%></p>
									</a>
								</li>
                                </ItemTemplate>
                                </asp:Repeater>
							</ul>
						</section>
						<!-- /Featured -->

						<!--/ Featured -->
						<section class="featured">
							<h2 class="head">Recently Online <a class="link" href="/Account/Search?type=online">see more</a></h2>
							<ul>
                              <asp:Repeater ID="repRecently" runat="server">
                              <ItemTemplate>
                                <li>
									<a class="area" href='<%#Utils.GetProfileLink(Container.DataItem)%>'>
										<figure class="photo"><img src='<%#MyUtils.GetImageUrl(Eval("mainphoto"),MyUtils.ImageSize.MEDIUM)%>' alt=""><%# (Eval("VIP").ToString()=="Y")?"<span class='vip'>VIP</span>":""%></figure>
										<p class="location"><%# Eval("age")%> / <%# Eval("plc")%></p>
									</a>
								</li>
                                </ItemTemplate>
                                </asp:Repeater>
							</ul>
						</section>
						<!-- /Featured -->


					</div>
				</div>
				<!-- /Content -->

			</div>
		</main>
		<!-- /Container -->


</asp:Content>

