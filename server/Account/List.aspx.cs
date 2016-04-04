using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_List : System.Web.UI.Page
{
    DB_Helper db = new DB_Helper();
    public string TYPE = string.Empty;
    public string sql;
    protected void Page_Load(object sender, EventArgs e)
    {
        string t = TYPE = Request.QueryString["t"];
        if (t != "favorites" && t != "viewed" && t != "favorited" && t != "blocked") return;
        sql = "exec SEARCH_USERS 1, 500, 0, " + MyUtils.ID_USER + ", '', 1, '*', 'users.id_user desc', '" + t + "'";
        DataSet d= db.GetDataSet(sql);
        Repeater1.DataSource = d;
        Repeater1.DataBind();
        if (d.Tables[0].Rows.Count==0)
        {
            norecords.Visible = true;
            if (t == "favorites") norecords.Text = "You don't have any favorites yet.";
            if (t == "viewed") norecords.Text = "Nobody viewed your profile yet.";
            if (t == "favorited") norecords.Text = "Nobody favorited your profile yet.";
            if (t == "blocked") norecords.Text = "You don't have any blocked users.";
        }

    }
}