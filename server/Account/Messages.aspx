<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Messages.aspx.cs" Inherits="Account_Messages" %>

<%@ Register Src="~/Account/QuickStart.ascx" TagPrefix="uc1" TagName="QuickStart" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<!-- Resents -->
<section class="resents">
<h2 class="h2 heading" runat="server" id="NormalHeadline">Recent Conversations</h2>
    <asp:Repeater ID="Repeater1" runat="server">
        <ItemTemplate>
            <a id="<%#Eval("id_offer") %>"/>
				<div class='<%# GetClass((int)Eval("news"),Eval("id_user_unlocked"))%>'>
					<p class="head"><a href='<%#Utils.GetProfileLink(Container.DataItem,"id_user_with")%>'><strong><%# Eval("username") %></strong> / <span class="small"><%# Eval("place") %></span></a> <time class="timeago time" datetime="<%# (new DateTime(((DateTime)Eval("lastmessage")).Ticks, DateTimeKind.Local)).ToString("o")%>"><%# Eval("lastmessage").ToString() %></time></p>
					<div class="panel-space item" data-id="<%#Eval("id_user_with") %>">
						<span class="fn" runat="server" visible='<%#((int)Eval("news"))>0%>'>
                            <%# Eval("locked").ToString()=="Locked" && MyUtils.IsMale ? "Locked":"New"%>
						</span>
						<a class="photo" href='<%#Utils.GetProfileLink(Container.DataItem,"id_user_with")%>'><img src='<%# MyUtils.GetImageUrl(Eval("MainPhoto"),MyUtils.ImageSize.TINY) %>' width="76" height="76" alt=""></a>
						<p class="name" style="font-size: 20px;padding-top: 7px;" ><%# GetDescription((int)Eval("messages"),(int)Eval("news")) %></p>



<asp:Button ID="but"  class="button button-green unlockbutton" Text='<%#"Unlock for "+ Eval("credits") +" credits"%>' CommandArgument='<%#Eval("id_offer") %>' runat="server" Visible='<%# Eval("locked").ToString()=="Locked" && MyUtils.IsMale %>' OnClick="but_Click"></asp:Button>
<asp:Button ID="Button1"  class="button" Text='Read Message' runat="server" CommandArgument='<%#Eval("id_offer") %>' Visible='<%# Eval("locked").ToString()=="Unlocked" || MyUtils.IsFemale %>' OnClick="but_Click"></asp:Button>


					</div>
				</div>
        </ItemTemplate>
    </asp:Repeater>
    
    <uc1:QuickStart runat="server" ID="QuickStart" />


</section>
<!-- /Resents -->

    <script type="text/javascript">
        jQuery(document).ready(function () {
            jQuery("time.timeago").timeago();
        });
    </script>

</asp:Content>

