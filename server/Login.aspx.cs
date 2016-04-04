using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Form.Attributes["data-form"] = "login";

        if (Request.QueryString["logout"] != null)
        {
            MyUtils.IAmOffline();
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("/");
            return;
        }

        MyUtils.EnsureHttps();

        welcome.Visible = Request.QueryString["new"] != null;
        if (MyUtils.IsLoggedIn() && !IsPostBack)
        {
            if (MyUtils.GetUserField("description").ToString() == "")
                Response.Redirect("~/Account/Registration");
            else
                Response.Redirect("~/Account/");
        }

        if (!IsPostBack)
        {
            if (Request.QueryString["logout"]!=null)
            {

            }

            HttpCookie c=Request.Cookies["login"];
            if (c != null) LoginUser.UserName = c.Value;
        }
    }

    string membership = "";

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (MyUtils.authenticate(LoginUser.UserName, LoginUser.Password, out membership) && !Utils.IsUserBan())
        {
            bool CreatePersistentCookie = this.LoginUser.RememberMeSet; //even if you close browser the account will stay logged in
            if (!MyUtils.IsUserAdmin())
            {
                DB_Helper db = new DB_Helper();
                db.Execute(string.Format("update Users set [lastlogin_time] = getdate(), ip_address={1} where id_user = {0}", MyUtils.ID_USER,MyUtils.safe(MyUtils.GetIP())));
            }

            FormsAuthentication.RedirectFromLoginPage(LoginUser.UserName, CreatePersistentCookie);
        }
    }

    protected override void OnPreRender(EventArgs e)
    {
        MyUtils.FindControlRecursive(this, "failuretextdiv").Visible = (((Literal)MyUtils.FindControlRecursive(this, "FailureText")).Text.Trim() != "");
        base.OnPreRender(e);
    }
    protected void LoginUser_Authenticate(object sender, AuthenticateEventArgs e)
    {
        e.Authenticated = MyUtils.authenticate(LoginUser.UserName, LoginUser.Password, out membership) && !Utils.IsUserBan();
    }
}
