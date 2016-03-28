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

        DataSet d=db.GetDataSet("exec GET_MESSAGE_LIST "+MyUtils.ID_USER);
        empty.Visible = d.Tables[0].Rows.Count == 0;
        if (empty.Visible)
        {
            empty.Text = "You have no messages. " + (MyUtils.GetUserField("sex").ToString() == "M" ? "Start with a search then send offers to the ladies you like." : "Start with a search then send winks to the men you like.");
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