<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="UploadPhotos.aspx.cs" Inherits="UploadPhotos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="pure-g">
        <div class="pure-u-1 pure-u-lg-19-24">
            <section>
                <div class="form form-upload">
                    <div class="info" runat="server">
                        <asp:Label runat="server" ID="lblMessage"></asp:Label>
                    </div>

                    <div class="form-space">
                        <h2 class="form-head">Upload Your Photos</h2>
                        <p class="inform">
                            <strong>96% of <%=MyUtils.GetUserField("sex").ToString()=="M" ? "wo":"" %>men are searching only for <%=MyUtils.GetUserField("sex").ToString()=="M" ? "":"wo" %>men with photos!</strong>
                            <br>
                            Your photo is the most important part of your profile. A good quality photo will increase your chances of getting more dates by 900% Photo must show you, fake photos will result in a ban.
                        </p>
                        <div runat="server" id="divError" visible="false">
                            <asp:Label runat="server" ID="lblError" />
                        </div>
                        <div class="filebox" style="">
                            <asp:FileUpload runat="server" ID="fileUploader" CssClass="inputfile" />
                            <label class="inputlabel" for="<%=fileUploader.ClientID%>"><i class="fa fa-paperclip"></i>Upload Photo</label>
                        <asp:Button runat="server" ID="btnComplete" CssClass="button" style="float:right" Text="Complete Registration" OnClick="btnComplete_Click" />
                        </div>
                        <asp:Button ID="btnAddImage"  Text="Add Image" runat="server" OnClick="btnAddImage_Click" style ="display:none;"/>
                        <div class="photos">
                            <h6 class="heading">Photos (<asp:Literal runat="server" ID="ltPhotosCount" />)</h6>
                            <asp:DataList ID="dlPhotos" runat="server" Width="100%" RepeatColumns="4" RepeatDirection="Horizontal">
                                <ItemTemplate>
                                    <figure class="photo <%#IsPrivate(Boolean.Parse(Eval("IsPrivate").ToString()))%>">
                                        <img id="itImage" alt="" src='<%# MyUtils.GetImageUrl(Eval("ImageGuid"),MyUtils.ImageSize.SMALL)%>' />
                                        <asp:LinkButton ID="lnkBtnRemoveImage" runat="server" CssClass ="close"
                                            CommandName="Remove" CommandArgument='<%#Eval("ImageID")%>' OnCommand="lnkBtnRemove_Command"></asp:LinkButton>
                                    </figure>

                                    <asp:LinkButton runat="server" ID ="btnSetAsMainPhoto" CssClass="button button-black" CommandArgument ='<%#Eval("ImageID")%>'  Text="Make Main Photo" OnCommand ="btnSetAsMainPhoto_Click" Visible ='<%#Boolean.Parse(Eval("IsMainPhoto").ToString()) == false%>'/>
                                    <asp:Label runat="server" ID ="lblMainPhoto" CssClass="button button-active" Visible ='<%#Eval("IsMainPhoto")%>'  Text="This is Main Photo" />
                                    
                                    <div class="form-line">
                                        <asp:CheckBox runat="server" ID="cbxPrivate" CssClass="css-checkbox" Text="Private" TagKey='<%#Eval("ImageID")%>' OnCheckedChanged="cbxPrivate_CheckedChanged" AutoPostBack="true" Checked ='<%#Eval("IsPrivate")%>'/>
                                    </div>
                                </ItemTemplate>
                            </asp:DataList>
                        </div>
                        <p class="inform">Photos need to be larger than 400 x 400px and you need to be in the photo. Also, no children in the photo. Pornography is not alowed. Partial nudity is allowed only in private photos. Your private photos will be shown only to users that you have sent an offer or a wink or acepted thier offer.</p>

                        <p class="small">
                            <strong>DISCLAIMER:</strong> We review all photos and reserve the right to modify photos as necessary before they are visible to other members. Most photos are reviewed within 24 hours. Once approved, they will appear as visible photos on your profile. If your photo does not meet the photo guidelines it will be deleted. We reserve the right to delete any photo for any reason.
							
                        </p>
                    </div>
                </div>

            </section>

        </div>
    </div>
</asp:Content>

