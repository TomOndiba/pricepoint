using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_Settings : System.Web.UI.Page
{
    DB_Helper db = new DB_Helper();

    protected void Page_Init(object sender, EventArgs e)
    {
        Button_CANCEL_SUB.Visible = MyUtils.SUBSCRIPTION_ACTIVE && MyUtils.GetUserFieldInt("CANCEL_FROM_NEXT_PERIOD", 0) == 0;
        PAID.Visible = MyUtils.SUBSCRIPTION_ACTIVE && MyUtils.GetUserFieldInt("CANCEL_FROM_NEXT_PERIOD", 1) == 1;
        if (PAID.Visible) PAID.Text = "<b>Subscription has been canceled, Membership will expire on "+ DateTime.Parse(MyUtils.GetUserField("NextPaymentDate").ToString()).ToString("MM/dd/yyyy")+ "</b><br><br>";
           //Select profile
           DataRow dataRow = db.GetRow(string.Format("select * from users where id_user={0}", MyUtils.ID_USER));

        //txtPassword.Attributes.Add("value", dataRow["password"].ToString());

        txtEmail.Text = dataRow["email"].ToString();

        cbxEmailNewMatches.Checked = Utils.GetBoolField(dataRow, "email_new_matches");
        cbxEmailWhenNewMessage.Checked = Utils.GetBoolField(dataRow, "email_when_new_message");
        cbxEmailWhenFavorited.Checked = Utils.GetBoolField(dataRow, "email_when_favorited");
        cbxemail_when_new_offer.Checked = Utils.GetBoolField(dataRow, "email_when_new_offer");
        cbxEmailNewsletter.Checked = Utils.GetBoolField(dataRow, "email_newsletter");

        cbxHideFromSearchResults.Checked = Utils.GetBoolField(dataRow, "hide_from_search_results");
        cbxHideOnViewedFavoritedList.Checked = Utils.GetBoolField(dataRow, "hide_on_viewed_favorited_list");
        cbxHideLastLogintime.Checked = Utils.GetBoolField(dataRow, "hide_last_logintime");
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        bool revalidate = false;
        try
        {
            string newemail = txtEmail.Text.Trim();
            int cnt = db.ExecuteScalarInt("select count(*) from users where email=" + MyUtils.safe(newemail) + " and id_user<>" + MyUtils.ID_USER);
            if (cnt > 0)
            {
                Session["message"] = "ERROR: this email is used by other user. You need to provide a new email.";
                return;
            }


            DataSet ds = db.CommandBuilder_LoadDataSet(string.Format("select * from users where id_user={0}", MyUtils.ID_USER));
            DataRow userRow = ds.Tables[0].Rows[0];

            if (txtPassword.Text.Trim() != string.Empty)
                userRow["password"] = txtPassword.Text.Trim();


            revalidate = userRow["email"].ToString().ToUpper() != newemail.ToUpper();


            userRow["email"] = newemail;
            if (revalidate) userRow["email_verified"] = 0;

            //cbx
            userRow["email_new_matches"] = cbxEmailNewMatches.Checked;
            userRow["email_when_new_message"] = cbxEmailWhenNewMessage.Checked;
            userRow["email_when_favorited"] = cbxEmailWhenFavorited.Checked;
            userRow["email_when_new_offer"] = cbxemail_when_new_offer.Checked;
            userRow["email_newsletter"] = cbxEmailNewsletter.Checked;

            userRow["hide_from_search_results"] = cbxHideFromSearchResults.Checked;
//            userRow["hide_on_viewed_favorited_list"] = cbxHideOnViewedFavoritedList.Checked;
  //          userRow["hide_last_logintime"] = cbxHideLastLogintime.Checked;

            db.CommandBuilder_SaveDataset();
        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }

        MyUtils.RefreshUserRow();

        if (revalidate)
        {
            RWorker.AddToEmailQueue("EMAIL_ACTIVATE", MyUtils.ID_USER);
        }

        Session["message"] = "Settings have been saved";
        Response.Redirect("~/Account/");
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        db.Execute("update users set status=-10 where id_user="+MyUtils.ID_USER);
        Session.Clear();
        Session["message"] = "Your account has been canceled.";
        FormsAuthentication.SignOut();
        Response.Redirect("/");
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        db.Execute("update users set CANCEL_FROM_NEXT_PERIOD=1 where id_user=" + MyUtils.ID_USER);
        string s=db.ExecuteScalarString("select NextPaymentDate from users where id_user=" + MyUtils.ID_USER);
        DateTime t = DateTime.Parse(s);
        Session["message"] = "Your subscription has been canceled and your VIP membership will expire on " + t.ToString("MM/dd/yyyy");
        MyUtils.RefreshUserRow();
    }
}