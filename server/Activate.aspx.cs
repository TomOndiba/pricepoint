using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_Activate : System.Web.UI.Page
{
    DB_Helper db = new DB_Helper();

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            lblAcitvated.Text = "";
            if (Request.QueryString["ActivateId"] != null)
            {
                int id = -1;
                if (int.TryParse(Request.QueryString["ActivateId"], out id))
                {
                    db.Execute(string.Format("update Users set email_verified=1 where id_user = {0}", id));
                    MyUtils.RefreshUserRow();
                    lblAcitvated.Text = "Your account has been activated.";
                    if (MyUtils.IsLoggedIn())
                    {
                        Session["message"] = lblAcitvated.Text;
                        Response.Redirect("/Account/", true);
                        return;
                    }
                }
            }

            if (lblAcitvated.Text == "")
            {
                lblAcitvated.Text = "Your account has not been activated. Check you activation email for correct link.";
            }
        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }
    }
}