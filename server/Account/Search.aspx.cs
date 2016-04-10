using Newtonsoft.Json;
using System;
using System.Data;
using System.Web;
using System.Web.Services;

public partial class Search : System.Web.UI.Page
{


    public Filter f;
    public string sql;
    protected void Page_Load(object sender, EventArgs e)
    {

        this.Form.Attributes["data-form"] = "filter";
//        this.Form.Attributes["class"] = "form-filter";
        this.Form.Attributes["novalidate"] = "1";
        this.Form.Attributes["onsubmit"] = "";
        this.Form.Action = "./Search";
        f = GetFilter();
        DataSet d = GetUsers(1, f.ToString(), out sql);
        UserList.DataSource = d;
        filterjson = d.Tables[1].Rows[0]["json"].ToString();
        UserList.DataBind();

        warning.Visible = d.Tables[0].Rows.Count == 0 && !f.IsDefault(true);

/*        sort.Value = f.orderby.ToString();
        sort.ClientIDMode = System.Web.UI.ClientIDMode.Static;
        sort.Attributes["name"] = sort.ID;
        distance.Value = f.distancemax.ToString();
        distance.ClientIDMode = System.Web.UI.ClientIDMode.Static;
        distance.Attributes["name"] = distance.ID;
        photos.Value = f.withphotos ? "true" : "false";
        photos.ClientIDMode = System.Web.UI.ClientIDMode.Static;
        */
    }

    public string IsSelected(string name, int v)
    {
        if (name=="sort")
        {
            if (f.orderby == (orderby_type) v) return "selected";
            return "";
        }

        if (name == "distance")
        {
            if (f.distancemax == v) return "selected";
            return "";
        }

        if (name == "photo")
        {
            if (f.withphotos && v == 1) return "selected";
            return "";
        }

        if (name == "ethnicity")
        {
            if (Array.IndexOf(f.ethnicity, (ethnicity_type_)v) >= 0)
            {
                return "selected";
            }
        }
        if (name == "body")
        {
            if (Array.IndexOf(f.body, (body_type)v) >= 0)
            {
                return "selected";
            }
        }
        return "";
    }

    public string filterjson="''";
    private static DataSet GetUsers(int index, string filter, out string sql)
    {
        //index = 1;
        DB_Helper db = new DB_Helper();

        int id_user = (int) MyUtils.GetUserField("id_user"); //currently logged in user

        if (string.IsNullOrEmpty(filter)) filter = db.ExecuteScalarString("select isnull(filter,'DEFAULT') from users where id_user=" + MyUtils.ID_USER);

        Filter f = Filter.CreateFromString(filter);

        sql = f.GetSQL(index,9);

        DataSet d = db.GetDataSet(sql);

        d.Tables[0].Columns.Add("mainphoto_");
        d.Tables[0].Columns.Add("online");
        d.Tables[0].Columns.Add("button_switch");
        foreach (DataRow r in d.Tables[0].Rows)
        {
            r["button_switch"] = GetButtonSwitch(r);
            r["mainphoto_"] = MyUtils.GetImageUrl(r, MyUtils.ImageSize.MEDIUM);
            r["online"] = MyUtils.IsOnline((int)r["id_user"]) ? "1" : "0";// ..GetImageUrl(r, MyUtils.ImageSize.MEDIUM);
        }
        d.Tables[0].Columns.Remove("mainphoto");
        d.Tables[0].Columns["mainphoto_"].ColumnName = "MainPhoto";

        d.Tables[0].TableName = "U";
        DataTable t = new DataTable();
        t.TableName = "filter";
        t.Columns.Add("json");
        t.Rows.Add(t.NewRow());
        t.Rows[0]["json"] = f.ToString();
        d.Tables.Add(t);
        return d;
    }

    private static string GetButtonSwitch(DataRow r)
    {
        string s = "SW_SENDOFFER";
        //SW_SENDOFFER, SW_OFFERSENT, SW_ACCEPT, SW_WINK, SW_MESSAGE


        int? mystate = null;
        int? thierstate = null;

        if (r["My_id_offer_state"] != DBNull.Value) mystate = Convert.ToInt32(r["My_id_offer_state"]);
        if (r["Their_id_offer_state"] != DBNull.Value) thierstate = Convert.ToInt32(r["Their_id_offer_state"]);

        //no offer yet
        if (mystate == null && thierstate == null)
        {
            if (MyUtils.IsFemale) return "SW_WINK";
            return "SW_SENDOFFER";
        }

        string offeredamount = "";
        if (r["IOfferedThem"] != DBNull.Value) offeredamount = Convert.ToDouble(r["IOfferedThem"]).ToString("C0");
        if (r["TheyOfferedMe"] != DBNull.Value) offeredamount = Convert.ToDouble(r["TheyOfferedMe"]).ToString("C0");

        //pending
        if (mystate == 403 && thierstate == null) return "SW_OFFERSENT";//OfferText.InnerText = offeredamount + " offer was sent";

        if (mystate == null && thierstate == 403)
        {
            //they are asking...
            //                DIV_ACCEPTCOUNTERREJECT.Visible = true;
            //                OfferText.InnerText = SheHe("She is asking ", "He is offering ") + " " + Convert.ToDouble(r["TheyOfferedMe"]).ToString("C0");
            return "SW_ACCEPT";
        }
        //rejected
        if (mystate == null && thierstate == 405)
        {
            //    OfferText.InnerText = "You've rejected " + SheHe("her", "his") + " " + Convert.ToDouble(r["TheyOfferedMe"]).ToString("C0") + " offer";
            return "SW_OFFERREJECTED";
        }
        if (mystate == 405 && thierstate == null)
        {
            //OfferText.InnerText = SheHe("She", "He") + " rejected your " + Convert.ToDouble(r["IOfferedThem"]).ToString("C0") + " offer";
            return "SW_OFFERREJECTED";
        }


        if (mystate == 404 || thierstate == 404)
        {

            bool IsUnlocked = r["Unlocked"].ToString() == "1";
            if (MyUtils.IsFemale || IsUnlocked)
                return "SW_MESSAGE";
            //BUT_SENDMESSAGE.InnerHtml = BUT_SENDMESSAGE.InnerHtml.Replace("[SEND MESSAGE]", "Send Message");
            else
            {
                return "SW_MESSAGE_UNLOCK";
                //            BUT_SENDMESSAGE.InnerHtml = BUT_SENDMESSAGE.InnerHtml.Replace("[SEND MESSAGE]", "Unlock Messaging for " + Convert.ToInt32(r["UnlockCredits"]) + " credits");
            }

//            return "SW_MESSAGE";
            //                BUT_SENDMESSAGE.Visible = true;
            //              agreedprice.Visible = true;
            //            agreedprice.InnerText = offeredamount;
        }


        //            if (OfferText.InnerText != "") OfferText.Style["display"] = "block";

        //          BUT_SENDMESSAGE.ServerClick += BUT_SENDMESSAGE_ServerClick;

        //Send offer is without gifts list
        //        if (MyUtils.IsFemale) BUT_SENDOFFER.Attributes.Add("data-counter", "1");



        return s;
    }

    private Filter GetFilter()
    {
        Filter f = new Filter();

        if (!IsPostBack)
        {
            string tp = Request.QueryString["type"];
            if (tp == "new")
            {
                f.orderby = orderby_type.NEWEST;
                f.withphotos = true;
                f.distancemax = 100;
                f.dontsave = true;
                return f;
            }
            if (tp == "online")
            {
                f.orderby = orderby_type.RECENT;
                f.withphotos = true;
                f.distancemax = 100;
                f.dontsave = true;
                return f;
            }
        }

        string fs = Request.Form["searchjson"];
        if (!string.IsNullOrEmpty(fs))
        {
            f = Filter.CreateFromString(fs);
        }
        else
        {
            string userfilterDB = MyUtils.GetUserField("filter") as string;
            if (!string.IsNullOrEmpty(userfilterDB))
            {
                f = Filter.CreateFromString(userfilterDB);
            }
        }

        if (this.IsPostBack && !f.dontsave)
        {
            EnsureFilterIsSaved(f);
        }

        return f;
    }

    private static void EnsureFilterIsSaved(Filter f)
    {
        string user_filter = MyUtils.GetUserField("filter") as string;
        string current_filter = f.ToString();
        if (user_filter != current_filter)
        {
            DB_Helper db = new DB_Helper();
            int id_user = MyUtils.ID_USER; //currently logged in user
            if (f.IsDefault()) current_filter = "DEFAULT";
            db.Execute("update users set filter=" + MyUtils.safe(current_filter) + " where id_user=" + id_user);
            MyUtils.RefreshUserRow();
        }
    }

    [WebMethod]
    public static string GetUsersPage(int pageIndex, string filter)
    {
        filter = HttpUtility.UrlDecode(filter);
        DB_Helper db = new DB_Helper();
        string sql;
        DataSet d = GetUsers(pageIndex, filter,out sql);
        return d.GetXml();
    }


}