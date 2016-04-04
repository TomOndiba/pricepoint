using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;

public partial class Forgot : System.Web.UI.Page
{

    protected void btnsend_Click(object sender, EventArgs e)
    {
        DB_Helper DB = new DB_Helper();
        if (txtEmail.Text.Length > 0)
        {
            int userId = DB.ExecuteScalarInt("select id_user from users where email='" + txtEmail.Text.Replace("'", "''") + "'", 0); // db.getActiveUserIdByEmail(txtEmail.Text);
            if (userId != 0)
            {
                EmailWrapper mw = new EmailWrapper();
                mw.SendTemplate("EMAIL_LOSTPASSWORD", userId);
                Session["SUCCESS"] = "Password has been sent to provided e-mail";
                Response.Redirect("/Forgot");
            }
            else
            {
                MyUtils.DisplayCustomMessageInValidationSummary("Provided e-mail is not registered as a valid user e-mail.", ValidationSummary1);
            }
        }
        //else
        //{
        //    MyUtils.DisplayCustomMessageInValidationSummary("E-mail is required.", ValidationSummary1);
        //}
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        MyUtils.showAction(Session, this);
    }
}
