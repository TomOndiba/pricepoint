using RobsCommonUtils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Sign_up : System.Web.UI.Page
{
    DB_Helper db = new DB_Helper();

    protected void Page_Init(object sender, EventArgs e)
    {

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Form.Attributes["data-form"] = "sign-up";

        if (!IsPostBack && Request.QueryString["s"]!=null)
        {
            ddlGender.SelectedValue = Request.QueryString["s"] == "M" ? "M" : "F";
            ClientScript.RegisterStartupScript(this.GetType(), "focus", "<script>document.getElementById('ContentPlaceHolder1_txtEmail').focus();</script>");
        } 


        if (System.Web.HttpContext.Current.User.Identity.IsAuthenticated)
            Response.Redirect("~/Account/");

        if (IsPostBack)
        {
            string Password = this.txtPassword.Text;
            txtPassword.Attributes.Add("value", Password);
        }
    }

    protected void btnSignUp_Click(object sender, EventArgs e)
    {
        int id_user;
        try
        {
            txtName.Text = txtName.Text.Trim();
            txtPassword.Text = txtPassword.Text.Trim();
            txtEmail.Text = txtEmail.Text.Trim();

            if (db.ExecuteScalarInt(string.Format("select count(*) from users where username = {0}", MyUtils.safe(txtName.Text))) > 0)
            {
                MyUtils.DisplayCustomMessageInValidationSummary("User with this Username already exists.", ValidationSummary1);
                return;
            }

            if (db.ExecuteScalarInt(string.Format("select count(*) from users where email = {0}", MyUtils.safe(txtEmail.Text))) > 0)
            {
                MyUtils.DisplayCustomMessageInValidationSummary("User with this Email Address already exists.", ValidationSummary1);
                return;
            }

            string xx = Profanity.TestAndMessage(txtName.Text);

            if (xx != null)
            {
                MyUtils.DisplayCustomMessageInValidationSummary("User name "+xx, ValidationSummary1);
                return;
            }


            DataSet d = db.CommandBuilder_LoadDataSet("select * from users where id_user=-1"); //get the columns schema
            DataRow n = d.Tables[0].NewRow();
            n["username"] = MyUtils.StripHTML(txtName.Text);
            n["password"] = txtPassword.Text;
            n["email"] = txtEmail.Text;
            n["sex"] = MyUtils.StripHTML(ddlGender.SelectedValue);

            string error = "";
            DateTime dt = birthday.GetBirthday(out error);
            if (error != "")
            {
                MyUtils.DisplayCustomMessageInValidationSummary(error, ValidationSummary1);
                return;
            }
            n["birthdate"] = dt;

            n["country"] = 28; // United States

            d.Tables[0].Rows.Add(n);
            id_user = db.CommandBuilder_SaveDataset(); //gets back @@identity

            EmailWrapper mw = new EmailWrapper();
            mw.SendTemplate("EMAIL_ACTIVATE", id_user);

            string membership = "";
            MyUtils.authenticate(txtName.Text, txtPassword.Text, out membership);
            FormsAuthentication.SetAuthCookie(txtName.Text, false);
            Response.Redirect("~/Account/Registration");
        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }
    }
}