<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Search.aspx.cs" Inherits="Search" EnableEventValidation="false" %>

<%@ Register src="~/OfferPopup.ascx" tagname="OfferPopup" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<input type="hidden" id="searchjson" name="searchjson" />
<script src="/js/SearchScroll.js"></script>

			<!-- Sort -->
			<div class="sort">
                <div class="form-filter">
					<div class="buttons-group">
						<div class="cell">
							<label for="sort"></label>
							<select id="sort" name="orderby" class="select" required="1">
								<option value="2" <%=IsSelected("sort",2)%>>Sort by: Newest Member</option>
								<option value="1" <%=IsSelected("sort",1)%>>Sort by: Distance</option>
								<option value="3" <%=IsSelected("sort",3)%>>Sort by: Recently Active</option>
							</select>
						</div>
						<div class="cell">
							<button class="button button-rosy" type="submit">Update Search</button>
						</div>
					</div>
					<div class="line">
						<div class="form-line form-line-distance">
							<label for="distance"></label>
							<select id="distance" name="distancemax" class="multiselect" required >
								<option <%=IsSelected("distance",0)%> value="0">Anywhere</option>
								<option <%=IsSelected("distance",15)%> value="15">Within 15 Miles</option>
								<option <%=IsSelected("distance",30)%> value="30">Within 30 Miles</option>
								<option <%=IsSelected("distance",60)%> value="60">Within 60 Miles</option>
								<option <%=IsSelected("distance",100)%> value="100">Within 100 Miles</option>
							</select>
						</div>
						<div class="form-line form-line-photos">
							<label for="photos"></label>
							<select id="photos" name="withphotos" class="multiselect" data-title="Photos" required>
								<option value="false" <%=IsSelected("photo",0)%>>With &amp; Without Photo</option>
								<option value="true" <%=IsSelected("photo",1)%>>Only With Photos</option>
							</select>
						</div>
						<div class="form-line form-line-age">
							<div class="btn-group select-age" data-min="16" data-max="70">
								<a class="toggle" href="#">Age <span class="agemin">18</span> to <span class="agemax">35</span> <span class="arrow"></span></a>
								<ul>
									<li><input class="from" onkeypress="return isNumberKey(event)" id="agemin" name="agemin" type="text" maxlength="2" value='<%=f.agemin %>' required> <label for="agemin">From Age</label></li>
									<li><input class="to" onkeypress="return isNumberKey(event)" id="agemax" name="agemax" type="text" maxlength="2" value='<%=f.agemax %>' required> <label for="agemax">To Age</label></li>
								</ul>
							</div>
						</div>
						<div class="form-line form-line-ethnicity">
							<label for="ethnicity_type"></label>
							<select id="ethnicity_type" name="ethnicity" class="multiselect" multiple data-title="Ethnicity Type" data-all="All Ethnicity Types" required>
								<option <%=IsSelected("ethnicity",273)%> value="273">Asian</option>
								<option <%=IsSelected("ethnicity",274)%> value="274">Black / African Descent</option>
								<option <%=IsSelected("ethnicity",275)%> value="275">Latin / Hispanic</option>
								<option <%=IsSelected("ethnicity",276)%> value="276">East Indian</option>
								<option <%=IsSelected("ethnicity",277)%> value="277">Middle Eastern</option>
								<option <%=IsSelected("ethnicity",278)%> value="278">Mixed</option>
								<option <%=IsSelected("ethnicity",279)%> value="279">American</option>
								<option <%=IsSelected("ethnicity",280)%> value="280">Pacific Islander</option>
								<option <%=IsSelected("ethnicity",281)%> value="281">White / Caucasian</option>
								<option <%=IsSelected("ethnicity",282)%> value="282">Other Ethnicity</option>
							</select>
						</div>
						<div class="form-line form-line-body">
							<label for="body_type"></label>
							<select id="body_type" name="body" class="multiselect" multiple data-title="Body Type" data-all="All Body Types" required>
								<option <%=IsSelected("body",268)%> value="268">Slim</option>
								<option <%=IsSelected("body",269)%> value="269">Athletic</option>
								<option <%=IsSelected("body",270)%> value="270">Average</option>
								<option <%=IsSelected("body",271)%> value="271">Extra Pounds</option>
								<option <%=IsSelected("body",272)%> value="272">Overweight</option>
							</select>
						</div>
					</div>
                    </div>
			</div>
			<!-- /Sort -->


			<!-- Warning -->
			<div class="warning" runat="server" id="warning">
				<p>We haven't found any users matching your criteria. Your search filter may be too restrictive. Try to loosen up your criteria or reset your search filter.</p>
				<a class="link" onclick="return resetfilter()" href="#">Reset Search Filter and Start Over</a>
			</div>
			<!-- /Warning -->

			<!-- Catalog -->
			<section class="catalog">
				<div id="usersdiv">
                <asp:Repeater ID="UserList" runat="server">
                <ItemTemplate>
                <div class="item" data-id='<%# Eval("id_user") %>' data-user='<%# Eval("usr") %>'>
					<div class="space">
						<figure class="photo">
							<a class="alink" onclick="return viewprofile(this)" href="#">
								<img class="photoM" src='<%#MyUtils.GetImageUrl(Eval("mainphoto"),MyUtils.ImageSize.MEDIUM)%>' width="313" height="313" alt=""><div <%#MyUtils.IsOnline((int)Eval("id_user")) ? "":"style='display:none'"%> class="rib-wrapper">
								<div class="rib">Online</div></div>
								<span class='vip' <%# Eval("VIP").ToString()=="Y"?"":"style='display:none'"%>>VIP</span> 
							</a>
						</figure>
						<div class="info">
							<a class="alink name" onclick="return viewprofile(this)" href="#"><%# Eval("usr") %></a>
                            <p class="location"><span class="age"><%# Eval("age") %></span> / <span class="loc"><%# Eval("plc") %></span><span class="range"><span class='dist'><%# Convert.ToInt32(Eval("dis"))%></span> miles</span></p>
							<p class="status"><%# Eval("tit") %></p>
							<div class="actions">
							<span class="cell SW <%# Eval("button_switch")%>">
    
    <a class='button button-icon js-popup SW_SENDOFFER' href="popup-offer.aspx"><span class='icon icon-offer'></span> Send Offer</a>
    <a class='button SW_OFFERSENT' href='#' onclick="return false;"> Offer Sent</a>
    <a class='button SW_OFFERREJECTED' href='#' onclick="return false;"> Rejected</a>
    <a class='button SW_ACCEPT' href='#' onclick="AcceptOffer(this)"><span class='icon icon-offer'></span> Accept Offer</a>
    <a class='button button-gray button-icon js-wink <%# Eval("wink").ToString()=="1" ? "active":""%> SW_WINK' href='#wink'> <span class='icon icon-wink'></span> <span class='sendwink'>Send Wink</span><span class='sentwink'>Wink Sent</span></a>
    <a class='button button-blue button-icon SW_MESSAGE' onclick="SendMessage(this)"><span class='icon icon-message'></span> Send Message</a>
    <a class='button button-green button-icon SW_MESSAGE_UNLOCK unlockbutton'><span class='icon icon-message'></span> Unlock </a>

								</span>
								<span class="cell"><a class="button button-gray button-icon js-favorite <%# Eval("favorite").ToString()=="1" ? "active" : "" %>" href="#favorite"><span class="icon icon-fav"></span> Favorite</a></span>
							</div>
						</div>
					</div>
				</div>
                </ItemTemplate>
                </asp:Repeater>
                </div>
			</section>
			<!-- /Catalog -->

<div style="width:100%;text-align:center">
        <img id="loader" alt="" src="/img/loading.gif" style="display: none" />
</div>

    <script type="text/javascript">
        filterjson = '<%=filterjson%>';
        $('.agemin', document).text(<%=f.agemin%>);
        $('.agemax', document).text(<%=f.agemax%>);
    </script>


				<uc1:OfferPopup ID="OfferPopup1" runat="server" />

   <!-- <%=sql %> -->

</asp:Content>

