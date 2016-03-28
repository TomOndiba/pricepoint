using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_Settings : System.Web.UI.Page
{
    DB_Helper db = new DB_Helper();

    protected void Page_Init(object sender, EventArgs e)
    {
        //Select profile
        DataRow dataRow = db.GetRow(string.Format("select * from users where id_user={0}", MyUtils.ID_USER));

        //txtPassword.Attributes.Add("value", dataRow["password"].ToString());

        txtEmail.Text = dataRow["email"].ToString();

        cbxEmailNewMatches.Checked = Utils.GetBoolField(dataRow, "email_new_matches");
        cbxEmailWhenNewMessage.Checked = Utils.GetBoolField(dataRow, "email_when_new_message");
        cbxEmailWhenFavorited.Checked = Utils.GetBoolField(dataRow, "email_when_favorited");
        cbxEmailNewsletter.Checked = Utils.GetBoolField(dataRow, "email_newsletter");

        cbxHideFromSearchResults.Checked = Utils.GetBoolField(dataRow, "hide_from_search_results");
        cbxHideOnViewedFavoritedList.Checked = Utils.GetBoolField(dataRow, "hide_on_viewed_favorited_list");
        cbxHideLastLogintime.Checked = Utils.GetBoolField(dataRow, "hide_last_logintime");
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {

        try
        {
            DataSet ds = db.CommandBuilder_LoadDataSet(string.Format("select * from users where id_user={0}", MyUtils.ID_USER));
            DataRow userRow = ds.Tables[0].Rows[0];

            if (txtPassword.Text.Trim() != string.Empty)
                userRow["password"] = txtPassword.Text.Trim();

            userRow["email"] = txtEmail.Text.Trim();

            //cbx
            userRow["email_new_matches"] = cbxEmailNewMatches.Checked;
            userRow["email_when_new_message"] = cbxEmailWhenNewMessage.Checked;
            userRow["email_when_favorited"] = cbxEmailWhenFavorited.Checked;
            userRow["email_newsletter"] = cbxEmailNewsletter.Checked;

            userRow["hide_from_search_results"] = cbxHideFromSearchResults.Checked;
            userRow["hide_on_viewed_favorited_list"] = cbxHideOnViewedFavoritedList.Checked;
            userRow["hide_last_logintime"] = cbxHideLastLogintime.Checked;

            db.CommandBuilder_SaveDataset();
        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }

        MyUtils.RefreshUserRow();

        Session["message"] = "Settings have been saved";
        Response.Redirect("~/Account/Default.aspx");
    }
}