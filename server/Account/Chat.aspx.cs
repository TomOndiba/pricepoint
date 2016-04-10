using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Messages_Chat : System.Web.UI.Page
{
    public int ID_USER;
    public int ID_USER_CHATWITH;
    public DataRow R;

    static DataTable SaveMessage2DBAndSelect(int id_user_from, int id_user_to, string message, string gift_list, int id_offer)
    {

        DB_Helper db = new DB_Helper();
        string s = "";
        if (MyUtils.IsFemale)
        {
            s = "select female_sent_msg from offers where id_offer=" + id_offer;
            int female_sent_msg = db.ExecuteScalarIntCache(s,0,5);
            if (female_sent_msg == 0)
            {
                db.Execute("update offers set female_sent_msg=1 where isnull(female_sent_msg,0)=0 and id_offer=" + id_offer + "; ");
                DB_Helper.InvalidateCache("SQL_" + s);
            }

        }
        return db.GetDataSet("insert into messages (id_user_from,id_user_to,text,gift_list,id_offer) OUTPUT inserted.* values (" + id_user_from + "," + id_user_to + "," + MyUtils.safe(message) + "," + MyUtils.safe(gift_list) + "," + id_offer + ");").Tables[0];
    }

    static DataTable GetMessagesForUser(int id_user, int id_user_with, int start_with_id = 0)
    {
        //IsFromMe gives 1 if the message was sent my me.
        DB_Helper db = new DB_Helper();

        string sql = "select " +
            "(SELECT top 1 [username] FROM [dbo].[Users] where [id_user] = m.id_user_from) FromUser," +
            "(SELECT top 1 [username] FROM[dbo].[Users] where[id_user] = m.id_user_to) ToUser, " +
            "case when id_user_from=" + id_user +
            " then 1 else 0 end as IsFromMe, * from messages m where ((id_user_from=" +
            id_user + " and id_user_to=" + id_user_with + ") or (id_user_to=" + id_user + " and id_user_from=" + id_user_with + ")) and m.[id_message] >= " + start_with_id + " order by [time] desc";
        sql += "; update messages set is_new = 0 where id_user_to =" + id_user + " and id_user_from = " + id_user_with +" and is_new = 1 and [id_message] >= " + start_with_id;
        return db.GetDataSet(sql).Tables[0];
    }
    public DataRow Offer;

    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Form.Attributes["data-form"] = "message";

        note.Visible = MyUtils.IsMale;

        ID_USER = (int)MyUtils.GetUserField("ID_USER"); //will redirect to login page if not logged in
        ID_USER_CHATWITH = Convert.ToInt32(Request.QueryString["id"]);

        DB_Helper db = new DB_Helper();

        int id_offer = db.ExecuteScalarInt("exec CAN_MESSAGE_WITH " + ID_USER + "," + ID_USER_CHATWITH, 0);
        if (id_offer == 0)
        {

            id_offer = db.ExecuteScalarInt("select id_offer from offers where id_offer_state=404 and (id_user_from=" + ID_USER_CHATWITH + " and id_user_to=" + MyUtils.ID_USER + ") or (id_user_from=" + MyUtils.ID_USER + " and id_user_to=" + ID_USER_CHATWITH + ")", 0);

            if (id_offer > 0)
            {
                Response.Redirect("/Account/Messages#" + id_offer, true);
                return;
            }

            Response.Clear();
            Response.Write("You don't have permission to send messages to this user.");
            Response.End();
        }

        R = db.GetRow("exec GET_USER_PROFILE " + ID_USER + "," + ID_USER_CHATWITH);
        if (R==null)
        {
            Response.Clear();
            Response.Write("This user doesn't exist.");
            Response.End();
        }

        Offer = db.GetRow("select amount from offers where (id_user_to=" + ID_USER + " and id_user_from=" + ID_USER_CHATWITH + ") or (id_user_to=" + ID_USER_CHATWITH + " and id_user_from=" + ID_USER + ")");





        //do some magic here with  ID_USER and ID_USER_CHATWITH

        //.......................................................


        //Example on how to insert message to DB
        //SaveMessage2DB(10002, 10003, "testing.... ", "1,2,3,4");

        //Example on how to get messages for user pair
        //DataTable T = GetMessagesForUser(10002, 10003);

    }

    [WebMethod]
    public static Message SendMessage(string message, string toUser, string giftIds)
    {
        DB_Helper db = new DB_Helper();
        var fromUser = MyUtils.ID_USER;



        message = MyUtils.StripHTML(message);
        giftIds = MyUtils.StripHTML(giftIds);
        int id_user_to = Convert.ToInt32(toUser);
        int id_offer = db.ExecuteScalarInt("exec CAN_MESSAGE_WITH " + Convert.ToInt32(fromUser) + "," + id_user_to, 0);
        if (id_offer == 0)
        {
            Message mm = new Message();
            mm.Text = "You don't have permission to send messages to this user.";
            return mm;
        }

        if (message.Trim() == "") return null;

        if (!string.IsNullOrEmpty(giftIds))
        {
            Gifts g = new Gifts(giftIds);
            string err = g.AddGifts2User(MyUtils.ID_USER, id_user_to);
            if (err != "")
            {
                Message mmm = new Message();
                mmm.Text = err;
                return mmm;
            }
        }

        var table = SaveMessage2DBAndSelect(fromUser, id_user_to, message, giftIds, id_offer);

        //make sure we don't send too many notification emails
        int unread_messages_in_10_mins = db.ExecuteScalarInt("select count(*) from Messages where id_user_from=" + fromUser + " and id_user_to=" + id_user_to + " and is_new = 1 and [time] > DATEADD(minute, -10, GETDATE())");

        if (unread_messages_in_10_mins<2) RWorker.AddToEmailQueue("EMAIL_NEWMESSAGE", id_user_to, MyUtils.ID_USER);



        DB_Helper.InvalidateCache("TOPCOUNTS_" + MyUtils.ID_USER);
        DB_Helper.InvalidateCache("TOPCOUNTS_" + id_user_to);

        var query = from p in table.AsEnumerable()
                    select new Message
                    {
                        Id = p.Field<int>("id_message"),
                        Text = p.Field<string>("text"),
                        From = new User
                        {
                            Name = "You",
                            Id = p.Field<int>("id_user_from")
                        },
                        To = new User
                        {
                            Name = "Female123", //TODO
                            Id = p.Field<int>("id_user_from")
                        },
                        DateTime = p.Field<DateTime>("time"),
                        IsFromMe = true
                    };
        Message m= query.First();

        if (!string.IsNullOrEmpty(giftIds))
        {
            m.Credits = Convert.ToInt32(MyUtils.GetUserField("credits"));
        }
        return m;
    }

    [WebMethod]
    public static List<Message> GetChatHistory(string toUser, int lastMessageId)
    {

        if (!MyUtils.IsLoggedIn())
        {
            List<Message> ml = new List<Message>();
            ml.Add(new Message());
            ml[0].Text = "REDIRTOLOGIN";
            return ml;
        }

        MyUtils.UserIsOnline();


        int userId = (int)MyUtils.GetUserField("ID_USER"); //will redirect to login page if not logged in

        System.Web.HttpContext.Current.Session["Heartbeat"] = DateTime.Now;

        DataTable messages = GetMessagesForUser(userId, Convert.ToInt32(toUser), ++lastMessageId);

        var query = from p in messages.AsEnumerable()
                    select new Message
                    {
                        Id = p.Field<int>("id_message"),
                        Text = p.Field<string>("text"),
                        From = new User
                        {
                            Name = p.Field<int>("id_user_from") == userId ? "You" : p.Field<string>("FromUser"),
                            Id = p.Field<int>("id_user_from")
                        },
                        To = new User
                        {
                            Name = p.Field<int>("id_user_from") == userId ? "You" : p.Field<string>("FromUser"),
                            Id = p.Field<int>("id_user_from")
                        },
                        DateTime = p.Field<DateTime>("time"),
                        IsFromMe = p.Field<int>("IsFromMe") == 1,
                        Gifts = p.Field<string>("gift_list")
                    };
        
        List<Message> list= query.Take(20).OrderBy(r => r.DateTime).ToList();

        Message m = new Message();
        m.Text = "ONLINE:" + (MyUtils.IsOnline(Convert.ToInt32(toUser)) ? "Y" : "N");
        list.Add(m);

        return list;
    }

    public class Message
    {
        public string Text { get; set; }
        [IgnoreDataMember]
        public DateTime DateTime { get; set; }
        public string Sent
        {
            get
            {
                return (new DateTime(this.DateTime.Ticks, DateTimeKind.Local)).ToString("o");
            }
        }
        public User From { get; set; }
        public User To { get; set; }
        public int Id { get; set; }
        public bool IsFromMe { get; set; }
        public string Gifts { get; set; }
        public int Credits { get; set; }
        public Message()
        {
            Credits = -1;
        }
    }

    public class User
    {
        public string Name { get; set; }
        public int Id { get; set; }
    }
}