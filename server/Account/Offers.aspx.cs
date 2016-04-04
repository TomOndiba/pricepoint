using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_Offers : System.Web.UI.Page
{
    public int Winks = 0;
    public int NewOffers = 0;
    public int Accepted = 0;
    public int Pending = 0;
    public int Rejected = 0;

    public string Gifts(string s)
    {
        Gifts g = new global::Gifts(s);
        return g.HTML(30);
    }
    public string GetReason(object oreason)
    {
        if (oreason==System.DBNull.Value) return "N/A";
        int r = Convert.ToInt32(oreason);
        switch (r)
        {
            case 1: return "Bid is too low";
            case 2: return "Too far away";
            case 3: return "Not interested";
        }

        return "N/A";

    }
    protected void but_Click(object sender, EventArgs aa)
    {
        Button bbb = sender as Button;
        //        RepeaterCommandEventArgs e = aa as RepeaterCommandEventArgs;
        Int32 id = Convert.ToInt32(bbb.CommandArgument);
        Utils.GoToSendMessage(id);
    }


    DB_Helper db = new DB_Helper();
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Form.Attributes["data-form"] = "offersform";

        offermenu.Visible = Request.QueryString["dates"] != "1";
        winksmenu.Visible = MyUtils.GetUserField("sex").ToString() == "M";
        string otype = Request.QueryString["type"];

        string type = otype;
        if (type == "Dates") type = "Accepted";
        if (MyUtils.GetOriginalURL().ToLower().Contains("/dates")) otype = "Dates";

        DataSet d = db.GetDataSet("exec GET_OFFER_LIST " + MyUtils.ID_USER);
        DataView v = new DataView(d.Tables[0]);
        v.RowFilter = "type='"+type+"'";
        if (type == "New") v.RowFilter += " or type='Countered'";
        Repeater1.DataSource = v;
        Repeater1.DataBind();

        foreach (DataRow r in d.Tables[0].Rows)
        {
            string s = r["type"].ToString();
            if (s == "Wink") Winks++;
            if (s == "New" || s== "Countered") NewOffers++;
            if (s == "Accepted") Accepted++;
            if (s == "Pending") Pending++;
            if (s == "Rejected") Rejected++;
        }

        QuickStart.Visible = v.Count == 0;
        if (QuickStart.Visible)
        {
//            string howtostart = (MyUtils.GetUserField("sex").ToString() == "M" ? "Start with a search then send offers to the ladies you like." : "Start with a search then send winks to the men you like.");

            string x = "Quick Start";
            if (type == "New") x = "<h2>You have no new offers yet</h2>";
            if (type == "Wink") x = "<h2>You have no winks yet </h2>";
            if (type == "Accepted") x = "<h2>You have no accepted offers </h2>";
            if (otype == "Dates") x = "<h2>You have no dates yet </h2>";
            if (type == "Pending") x = "<h2>You have no pending offers </h2>";
            if (type == "Rejected") x = "<h2>You have no rejected offers </h2>";

            QuickStart.Title = x;
        }



    }
}