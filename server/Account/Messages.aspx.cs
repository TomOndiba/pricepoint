using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_Messages : System.Web.UI.Page
{
    DB_Helper db = new DB_Helper();

    public string GetDescription(int mess, int news)
    {
        string old = "old";
        if (news > 0) { mess = news; old = "new"; }
        string s = "";
        if (mess > 1) s = "s";
        return mess + " " + old + " message" + s;
    }

    public string GetClass(int news, object id_user_unlocked)
    {
        if (id_user_unlocked == DBNull.Value && MyUtils.IsMale) return "panel panel-locked";
        if (news > 0) return "panel panel-new";
        return "panel";
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        var SendMessageTo = Request.QueryString["SendMessageTo"];
        if (!string.IsNullOrEmpty(SendMessageTo))
        {
            int id = Convert.ToInt32(SendMessageTo);
            int id_offer = db.ExecuteScalarInt("select id_offer from offers where (id_user_from=" + id + " and id_user_to=" + MyUtils.ID_USER + ") or (id_user_from=" + MyUtils.ID_USER + " and id_user_to=" + id + ")");
            Utils.GoToSendMessage(id_offer);
            return;
        }

        DataSet d=db.GetDataSet("exec GET_MESSAGE_LIST "+MyUtils.ID_USER);
        QuickStart.Visible = d.Tables[0].Rows.Count == 0;
        if (QuickStart.Visible)
        {
            NormalHeadline.Visible = false;
            QuickStart.Title = "<h2>You have no messages yet</h2>";
        }
        Repeater1.DataSource = d;
        Repeater1.DataBind();
    }

    protected void but_Click(object sender, EventArgs e)
    {
        Button bbb = sender as Button;
        Int32 id = Convert.ToInt32(bbb.CommandArgument);
        Utils.GoToSendMessage(id);
    }
}