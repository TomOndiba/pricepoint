using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_VerifyEmail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) txtEmail.Text = MyUtils.GetUserField("email").ToString();

    }

    protected void btnSendCode_Click(object sender, EventArgs e)
    {

        if (regexEmailValid.IsValid && RequiredFieldValidator1.IsValid)
        {
            DB_Helper db = new DB_Helper();
            string em =txtEmail.Text;

            if (em.StartsWith("ACTIVATE"))
            {
                db.Execute(string.Format("update Users set email_verified=1 where id_user = {0}", MyUtils.ID_USER));
                MyUtils.RefreshUserRow();
            }
            else
            {

                int id_user = db.ExecuteScalarInt("select id_user from users where email=" + MyUtils.safe(em), 0);
                if (id_user > 0 && id_user != MyUtils.ID_USER)
                {
                    Session["message"] = "ERROR: This email is already used by a different user.";
                    return;
                }
                db.Execute("update users set email=" + MyUtils.safe(em) + " where id_user=" + MyUtils.ID_USER);
                MyUtils.RefreshUserRow();
                EmailWrapper mw = new EmailWrapper();
                mw.SendTemplate("EMAIL_ACTIVATE", MyUtils.ID_USER);
                Session["message"] = "OK: Activation email was sent. Please check your inbox.";
            }
        }
        else Session["message"] = "ERROR: Invalid email.";

        bool needtoverify = Convert.ToUInt32(MyUtils.GetUserField("email_verified")) == 0;
        if (!needtoverify)
        {
            Response.Redirect("/Account/");
            Session["message"] = "Account is active.";
        }

    }
}