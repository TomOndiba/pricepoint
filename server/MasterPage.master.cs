using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    public string formclass = "";
    public const string filesExt = ".jpg";
    public string cssclassname = "";


    DB_Helper db = new DB_Helper();

    public string WrapperStyle = "";
    public string HomeLink = "/";

    public DataRow TOPCOUNTS;

    public string GetCount(string s)
    {
        if (TOPCOUNTS[s] == DBNull.Value) return "";
        int z = (int)TOPCOUNTS[s];
        if (z == 0) return "";
        string a = "<span class='mobile-hidden'>-</span> <span class='newredcount'>" + TOPCOUNTS[s] + "</span>";
        return a;
    }

    protected void Page_Load(object sender, EventArgs e)
    {


        if (Request.FilePath.ToLower().Contains("chat.aspx"))
        {
            form1.Style.Add("height", "100%");
            footer.Visible = false;
            cssclassname = "conversation-page";
            form1.Attributes["data-form"] = "form-message";
        }

        if (Request.CurrentExecutionFilePath == "/Login.aspx")
            btnLogin.Visible = false;

        if (Request.CurrentExecutionFilePath == "/Sign-up.aspx")
            btnSignUp.Visible = false;

        if (MyUtils.IsLoggedIn())
        {
            bool is_registration = Request.CurrentExecutionFilePath.ToLower().Contains("/account/registration") ||
                        Request.CurrentExecutionFilePath.ToLower().Contains("/account/uploadphotos");

            if (!is_registration)
            {
                bool needtoverify = Convert.ToUInt32(MyUtils.GetUserField("email_verified")) == 0;
                buycredits.Visible = !needtoverify;
                if (needtoverify && !Request.CurrentExecutionFilePath.ToLower().Contains("/account/verifyemail"))
                {
                    Response.Redirect("~/Account/VerifyEmail", true);
                    return;
                }
            }


            if (Utils.IsUserBan()) // in case of cookie
                Response.Redirect("~/Login?logout=1");

            if (Utils.IsUserReject())
            {
                if (!is_registration)
                {
                    Session["message"] = "Your account has been rejected. Please, correct your profile and photos.";
                    Response.Redirect("~/Account/Registration");
                }
            }

            MyUtils.UserIsOnline();

            HomeLink = "/Account/";
            divButtons.Visible = false;
            lblUserName.Text = MyUtils.GetUserField("username").ToString();            
            topdiv.Visible = true;

            TOPCOUNTS = db.GetRowCache("exec GET_MENU_COUNTS " + MyUtils.ID_USER, 20, "TOPCOUNTS_" + MyUtils.ID_USER);


            if (Request.CurrentExecutionFilePath == "/Account/Registration" ||
                        (Request.QueryString["hidemenu"] != null))
            {
                topdiv.Visible = false;
                divUserName.Visible = false;
            }
            else if (Request.CurrentExecutionFilePath != "/Account/Registration" && Request.CurrentExecutionFilePath != "/Activate.aspx" &&
                        string.IsNullOrEmpty(MyUtils.GetUserField("description").ToString()))
                    Response.Redirect("~/Account/Registration");

            if (MyUtils.IsUserAdmin())
            {
                hrefPhotos.Visible = true;
                hrefProfiles.Visible = true;
            }


        }
        else
        {
            divUserName.Visible = false;
        }


        if (Request.CurrentExecutionFilePath.ToLower() == "/default.aspx")
        {
            WrapperStyle = "max-width:none;padding:0;";
//            topdiv.Visible = false;
        }



    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        if (MyUtils.IsLoggedIn())
        {
            imgUserMainPhoto.ImageUrl = GetUserPhotoUrl();
        }
        MyUtils.ShowJsAlert();
    }

    private string GetUserPhotoUrl()
    {
        string photoGuid = null;

        if (Session["MainPhotoGuid"] == null)
        {
            var mainPhotoRow = db.GetRow(string.Format("select * from users where id_user = {0}", MyUtils.ID_USER));
            if (mainPhotoRow != null)
            {
                var mainPhotoId = mainPhotoRow["id_photo"];

                if (!(mainPhotoId is DBNull))
                {
                    DataSet photoData = db.GetDataSet(string.Format("select * from photos where id_photo={0}", mainPhotoId.ToString()));
                    if (photoData.Tables.Count > 0 && photoData.Tables[0].Rows.Count > 0)
                    {
                        photoGuid = photoData.Tables[0].Rows[0]["GUID"].ToString();
                        Session["MainPhotoGuid"] = photoGuid;
                    }
                }
            }
        }
        else
        {
            photoGuid = Session["MainPhotoGuid"].ToString();
        }

        if (!string.IsNullOrEmpty(photoGuid))
        {
            return MyUtils.GetImageUrl(photoGuid, MyUtils.ImageSize.TINY);
        }



        return "/img/NoPhoto" + MyUtils.GetUserField("sex") + "-s.jpg";
    }

}
