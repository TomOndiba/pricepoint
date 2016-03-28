using Newtonsoft.Json;
using System;
using System.Data;
using System.Web;
using System.Web.Services;

public partial class Search : System.Web.UI.Page
{
    public enum body_type { Slim = 268, Athletic = 269, Average = 270, ExtraPounds = 271, Overweight = 272 };
    public enum ethnicity_type_ { Asian =273, Black=274, Latin=275, Indian=276, Middle=277, Mixed=278, American=279, Islander=280, White=281, Other=282};
    public enum orderby_type { DISTANCE = 1, NEWEST = 2, RECENT = 3 };

    public class Filter
    { 
        public Filter()
        {
            SetDefault();
        }

        private void SetDefault()
        {
            // Default Values for Filter
            agemin = 18;
            agemax = 65;
            ethnicity = new ethnicity_type_[] { ethnicity_type_.Asian, ethnicity_type_.American, ethnicity_type_.Black, ethnicity_type_.Indian, ethnicity_type_.Islander, ethnicity_type_.Latin, ethnicity_type_.Middle, ethnicity_type_.Mixed, ethnicity_type_.Other, ethnicity_type_.White };
            body = new body_type[] { body_type.Athletic, body_type.ExtraPounds, body_type.Overweight, body_type.Slim, body_type.Average };
            withphotos = false;
            orderby = orderby_type.DISTANCE;
            distancemax = 0;
        }

        public bool IsDefault(bool TestWithoutOrderBy=false)
        {
            Filter b = new Filter();

            if (agemin == b.agemin && 
                agemax == b.agemax && 
                ethnicity.Length == b.ethnicity.Length && 
                body.Length == b.body.Length && 
                withphotos == b.withphotos && 
                (TestWithoutOrderBy || orderby == b.orderby) &&
                distancemax == b.distancemax) return true;
            return false;
        }

        public int agemin = 0;
        public int agemax = 0;
        public int distancemax = 0;
        public orderby_type orderby = orderby_type.NEWEST;
        public bool withphotos = false;
        public body_type[] body = new body_type[] { };
        public ethnicity_type_[] ethnicity = new ethnicity_type_[] { };
        public bool dontsave = false;

        public override string ToString()
        {
            string s = JsonConvert.SerializeObject(this);
            return s;
        }
        public static Filter CreateFromString(string j)
        {
            Filter f;
            if (j == "DEFAULT") f = new Filter();
            else f = JsonConvert.DeserializeObject<Filter>(j);
            if (f.agemin < 18) f.agemin = 18;
            if (f.agemin>f.agemax)
            {
                int z = f.agemin;
                f.agemin = f.agemax;
                f.agemax = z;
            }
            return f;
        }
        public string GetOrderBy()
        {
            if (orderby == orderby_type.DISTANCE) return "isnull(Cast([dbo].[fnCalcDistanceMiles](@lat,@long,latitude,longitude) as Decimal(6,0)),0)";
            if (orderby == orderby_type.NEWEST) return "id_user desc";
            if (orderby == orderby_type.RECENT) return "lastlogin_time desc";
            return "id_user desc"; //default
        }
        public string GetWhere()
        {
            string s = "";
            if ((agemax != 65 && agemax!=0) || (agemin > 18 || agemin!=0))
            {
                s = insert(s, "cast (datediff(year,birthdate,getdate()-datepart(dy,birthdate)+1) as int) BETWEEN " + agemin + " and " + (agemax == 0 ? 120 : agemax));
            }
            if (distancemax > 0) s = insert(s, "isnull(Cast([dbo].[fnCalcDistanceMiles](@lat,@long,latitude,longitude) as Decimal(6,0)),0)<=" + distancemax);
            if (withphotos) s = insert(s,"id_photo is not null");
            if (body.Length > 0 && body.Length<5)
            {
                string list = "";
                foreach (body_type b in body)
                {
                    if (list != "") list += ","; list += (int)b;
                }
                s =insert(s,"id_bodytype in (" + list + ")");
            }
            if (ethnicity.Length > 0 && ethnicity.Length<10)
            {
                string list = "";
                foreach (ethnicity_type_ b in ethnicity)
                {
                    if (list != "") list += ","; list += (int)b;
                }
                s=insert(s,"id_ethnicity in (" + list + ")");
            }
            return s;
        }

        private string insert(string s, string v)
        {
            if (s != "") s += " and ";
            s += v;
            return s;
        }
    }
    public Filter f;
    public string sql;
    protected void Page_Load(object sender, EventArgs e)
    {

        this.Form.Attributes["data-form"] = "filter";
//        this.Form.Attributes["class"] = "form-filter";
        this.Form.Attributes["novalidate"] = "1";
        this.Form.Attributes["onsubmit"] = "";
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
        string where = f.GetWhere();
        string orderby = f.GetOrderBy();
        int max_distance = 0;
        int page_length = 9;

        where += " and sex=" + (MyUtils.GetUserField("sex") as string == "F" ? "'M'" : "'F'");
        //Select only these columns to prevent large dataset comming to IIS
        //shorting the names to save ajax xml bandwith and make it loading fast
        string select = "GUID, UsersTable.id_user, username as usr,place as plc,title as tit,distance as dis,age";
        sql = "exec SEARCH_USERS " + index + "," + page_length + "," + max_distance + "," + id_user + "," + MyUtils.safe(where) + ",1,'" + select + "','" + orderby + "'";
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
            return "SW_MESSAGE";
            //                BUT_SENDMESSAGE.Visible = true;
            //              agreedprice.Visible = true;
            //            agreedprice.InnerText = offeredamount;
        }

        bool IsUnlocked = r["Unlocked"].ToString() == "1";
        if (MyUtils.IsFemale || IsUnlocked)
            return "SW_MESSAGE";
        //BUT_SENDMESSAGE.InnerHtml = BUT_SENDMESSAGE.InnerHtml.Replace("[SEND MESSAGE]", "Send Message");
        else
        {
            return "SW_MESSAGE";
//            BUT_SENDMESSAGE.InnerHtml = BUT_SENDMESSAGE.InnerHtml.Replace("[SEND MESSAGE]", "Unlock Messaging for " + Convert.ToInt32(r["UnlockCredits"]) + " credits");
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