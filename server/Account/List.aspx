<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="List.aspx.cs" Inherits="Account_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<ul class="links-group" runat="server" id="Ul1">
				<li><a <%=MyUtils.MenuLink("/Account/List?t=favorites")%> ><span class="icon icon-new"></span> My Favorites</a></li>
				<li><a <%=MyUtils.MenuLink("/Account/List?t=viewed")%> ><span class="icon icon-tick"></span> Who Viewed Me </a></li>
				<li runat="server" id="Li1" ><a <%=MyUtils.MenuLink("/Account/List?t=favorited")%> ><span class="icon icon-wink"></span> Who Favotited Me  </a></li>
				<li runat="server" id="Li2" ><a <%=MyUtils.MenuLink("/Account/List?t=blocked")%> ><span class="icon icon-sandglass"></span> Blocked List </a></li>
</ul>
    <br />

<section class="offers">
<div class="pure-g">
                        
    <asp:Repeater ID="Repeater1" runat="server" >
        <ItemTemplate>
					<div class="pure-u-1 pure-u-sm-12-24 pure-u-lg-8-24">
						<div class="panel panel-pending" data-id="<%# Eval("id_user") %>" data-user="<%# Eval("username") %>">
							<div class="panel-space">
								<div class="info">
									<a class="photo" href='<%#Utils.GetProfileLink(Container.DataItem)%>'><img src='<%# MyUtils.GetImageUrl(Eval("MainPhoto"),MyUtils.ImageSize.TINY) %>' alt=""></a>
									<p class="name"><a class="name" href='<%#Utils.GetProfileLink(Container.DataItem)%>'><%# Eval("username") %></a></p>
									<p class="location"><%# Eval("age") %> / <%# Eval("place") %></p>
								</div>
                                <div class="buttons">
                                    <%if (TYPE == "favorites")
                                        {%>
									<div class="cell"><a name="btnUnfavorite" class="button button-black js-withdraw-offer" href="#">Unfavorite</a></div>
                                    <%}%>
                                    <%if (TYPE == "blocked")
                                        {%>
									<div class="cell"><a name="btnUnblock" class="button button-black js-withdraw-offer" href="#">Unblock</a></div>
                                    <%}%>
								</div>
							</div>
						</div>
					</div>
        </ItemTemplate>
    </asp:Repeater>
    <div class="text" style="margin-left:5px">
    <asp:Literal runat="server" ID="norecords" Text="No records." Visible="false" />
    </div>
</div>
</section>

<script type="text/javascript">
    $(document).ready(function () {

    // Unblock
    $('a[name=btnUnblock]').click(function () {

        var id_user = $(this).closest('[data-id]').data('id');
        var userName = $(this).closest('[data-username]').data('username');

        $(this).closest('[data-id]').each(function () {

            $(this).fadeOut(500, function () {
                $(this).closest('.pure-u-1').remove();
            });

        $.ajax({
            type: "POST",
            data: "{'id_user':'" + id_user + "',username:'" + userName + "'}",
            url: '../WebService.asmx/Unblock',
            contentType: "application/json",
            success: function (data) {
                if (data.d.indexOf('OK') >= 0) {
                    showAlert(data.d.replace('OK: ', ''));
                } else {
                    showError(data.d.replace('ERROR: ', ''));
                }
            },
            error: function (jqXHR, exception) {
                showError('Error ' + data.status + ": " + data.statusText);
            }
        });
        });
        event.preventDefault();
    });

    // UnFavorite
    $('a[name=btnUnfavorite]').click(function () {

        var id_user = $(this).closest('[data-id]').data('id');

        $(this).closest('[data-id]').each(function () {

            $(this).fadeOut(500, function () {
                $(this).closest('.pure-u-1').remove();
            });

            $.ajax({
                type: "POST",
                data: "{'id_user':'" + id_user + "','on_off':'false'}",
                url: '../WebService.asmx/Favorite',
                contentType: "application/json",
                success: function (data) {
                    if (data.d.indexOf('OK') >= 0) {
                        showAlert(data.d.replace('OK: ', ''));
                    } else {
                        showError(data.d.replace('ERROR: ', ''));
                    }
                },
                error: function (jqXHR, exception) {
                    showError('Error ' + jqXHR.status + ": " + jqXHR.statusText);
                }
            });
        });
        event.preventDefault();
    });

})
</script>

<!--<%=sql %> -->
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="bottom" Runat="Server">
</asp:Content>

