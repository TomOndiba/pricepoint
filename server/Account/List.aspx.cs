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


    }
}