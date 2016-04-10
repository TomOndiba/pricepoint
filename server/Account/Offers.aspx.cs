using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_Offers : System.Web.UI.Page
{

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

    public Utils u = new Utils();

    DB_Helper db = new DB_Helper();
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Form.Attributes["data-form"] = "offersform";

        offermenu.Visible = Request.QueryString["dates"] != "1";
        winksmenu.Visible = MyUtils.GetUserField("sex").ToString() == "M";
        string otype = Request.QueryString["type"];
        if (otype == null) otype = "New";
        string type = otype;
        if (type == "Dates") type = "Accepted";
        if (MyUtils.GetOriginalURL().ToLower().Contains("/dates")) otype = "Dates";


        DataTable T = u.GetOffersAndWinks();

        DataView v = new DataView(T);
        v.RowFilter = "type='" + type + "'";
        if (type == "New") v.RowFilter += " or type='Countered'";
        Repeater1.DataSource = v;
        Repeater1.DataBind();


        if (type == "New" && v.Count == 0 && Request.QueryString["type"] == null) Response.Redirect("/Account/Offers?type=Wink", true);
        ShowEmptyRecords(otype, type, v.Count);

    }

    private void ShowEmptyRecords(string otype, string type, int vCount)
    {
        QuickStart.Visible = vCount == 0;
        if (QuickStart.Visible)
        {
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


    protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        DataRowView r= e.Item.DataItem as DataRowView;
        if (r != null)
        {
            if (MyUtils.IsFemale && (r["female_sent_msg"]==DBNull.Value || Convert.ToInt32(r["female_sent_msg"]) == 0))
            {
                Button t = (Button)e.Item.FindControl("Button1");
                t.Text = "Send First Message";
                t.CssClass = t.CssClass.Replace("button-blue", "button-green");
            }
        }
    }
}