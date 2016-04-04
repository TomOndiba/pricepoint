using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public class PhotoData
{
    public Guid  GuidPhoto { get; set; }
        
    public int idPhoto { get; set; }

    public int idUser { get; set; }

    public bool isPrivate { get; set; }

    public bool isApproved { get; set; }

    public bool isMainPhoto { get; set; }
}

public partial class UploadPhotos : System.Web.UI.Page
{
    private const int maxPhotosCount = 8;
    private const string photoPath = "../UserImages/";

    DB_Helper db = new DB_Helper();

    DataSet dsImages = new DataSet();

    private void initDS()
    {
        dsImages.Tables.Add("Images");
        dsImages.Tables["Images"].Columns.Add("filePath");
        dsImages.Tables["Images"].Columns.Add("ImageGuid");
        dsImages.Tables["Images"].Columns.Add("ImageID" ,Type.GetType("System.Int32"));
        dsImages.Tables["Images"].Columns.Add("IsMainPhoto", Type.GetType("System.Boolean"));
        dsImages.Tables["Images"].Columns.Add("IsPrivate", Type.GetType("System.Boolean"));

    }

    protected void Page_Init(object sender, EventArgs e)
    {
        if (Request.QueryString["hidemenu"] != null)
            btnComplete.Visible = true;
        else
            btnComplete.Visible = false;

        divError.Visible = false;


 //       if (Session["dsImages"] == null)
        {
            var photosList = GetUserPhotosFromDb();
            this.initDS();

            foreach (var ph in photosList)
            {
                AddPhotoToDataSet(null, ph.GuidPhoto.ToString(), ph.idPhoto, ph.isMainPhoto, ph.isPrivate);
            }

            Session.Add("dsImages", dsImages);
            OrderDataList();
            bindDataList();
        }
     //   else
        //{
       //     dsImages = (DataSet)Session["dsImages"];
         //   bindDataList();
       // }
    }
    
    protected void Page_PreRender(object sender, EventArgs e)
    {
        ltPhotosCount.Text = GetPhotosCount().ToString();

        var id = "$get('" + btnAddImage.ClientID + "')";

        fileUploader.Attributes.Add("onchange", string.Format("__doPostBack('{0}','');", btnAddImage.UniqueID));
    }

    private void AddPhotoToDataSet(string filePath, string imageGuid, int imageId, bool isMainPhoto, bool isPrivate)
    {
        DataRow dr = dsImages.Tables[0].NewRow();
        dr["filePath"] = filePath;
        dr["ImageGuid"] = imageGuid;
        dr["ImageID"] = imageId;
        dr["IsMainPhoto"] = isMainPhoto;
        dr["IsPrivate"] = isPrivate;

        dsImages.Tables["Images"].Rows.Add(dr);
    }

    protected void btnAddImage_Click(object sender, EventArgs e)
    {
        Tuple<int, int> imageSizes;

        if (dsImages.Tables["Images"].Rows.Count < maxPhotosCount)
        {
            if (fileUploader != null && fileUploader.PostedFile.ContentLength > 0)
            {
                Stream st = fileUploader.PostedFile.InputStream;

                try
                {
                    using (var imgPhoto = System.Drawing.Image.FromStream(st))
                    {
                        imageSizes = new Tuple<int, int>(imgPhoto.Height, imgPhoto.Width);
                    }
                }
                catch
                {
                    divError.Visible = true;
                    lblError.Text = "This file format is not supported, please upload [.jpeg],[.gif] or [.png] formats only";
                    return;
                }

                string guid = RobsCommonUtils.AmazonS3.SaveImageToFileandAmazon(st,photoPath);


                //Save to DB
                int id_photo = SavePhotoToDb(guid, imageSizes);



                AddPhotoToDataSet(photoPath + fileUploader.PostedFile.FileName, guid, id_photo, false, false);

                MakePhotoMain();

                Session["message"] = "OK: Photo has been successfully uploaded.";
            }
            else
                if (dsImages.Tables["Images"].Rows.Count == 0)
            {
                divError.Visible = true;
                lblError.Text = "You need to upload at least one image!";
            }
        }
        else
        {
            divError.Visible = true;
            lblError.Text = "You can upload only " + maxPhotosCount + " photos.";
        }


        this.bindDataList();
    }



    private void MakePhotoMain()
    {
        if (dsImages.Tables["Images"].Rows.Count == 0)
        {
            Session["MainPhotoGuid"] = null;
        }
        if (dsImages.Tables["Images"].Rows.Count == 1)
        {
            MakeMainPhotoInDB(dsImages.Tables["Images"].Rows[0]["ImageID"].ToString());
        }
        if (dsImages.Tables["Images"].Rows.Count > 1 && dsImages.Tables["Images"].Select().Where(x => Boolean.Parse(x["IsMainPhoto"].ToString())).FirstOrDefault() == null)
        {
            MakeMainPhotoInDB(dsImages.Tables["Images"].Rows[0]["ImageID"].ToString());
        }
    }

    private void bindDataList()
    {

        if (dsImages.Tables["Images"].Rows.Count > 0)
        {

            DataTable dt = new DataTable();
            for (int i = 0; i < dsImages.Tables["Images"].Rows.Count; i++)
            {
                dt = dsImages.Tables[0];

                if (dt.Rows.Count > 0)
                {
                    dlPhotos.DataSource = dt;
                    dlPhotos.DataKeyField = "ImageID";
                    dlPhotos.DataBind();
                }
            }
        }
        else
        {
            dlPhotos.DataSource = "";
            dlPhotos.DataBind();
        }
    }

    private void OrderDataList()
    {
        var drMain = dsImages.Tables["Images"].Select().Where(x => Boolean.Parse(x["IsMainPhoto"].ToString())).FirstOrDefault();
        DataTable dt = dsImages.Tables["Images"];
        DataRow drNew = dt.NewRow();

        if (drMain != null)
        {
            for (int i = 0; i < drMain.ItemArray.Length; i++)
                drNew[i] = drMain[i];

            dsImages.Tables["Images"].Rows.Remove(drMain);
            dsImages.Tables["Images"].Rows.InsertAt(drNew, 0);
        }
    }

    protected void lnkBtnRemove_Command(object sender, CommandEventArgs e)
    {

        foreach (DataRow dr in dsImages.Tables[0].Rows)
        {
            if (dr["ImageID"].ToString() == e.CommandArgument.ToString())
            {
                String filename = Server.MapPath(photoPath) + dr["ImageGuid"].ToString() + "-T.jpg";
                String filename1 = Server.MapPath(photoPath) + dr["ImageGuid"].ToString() + "-S.jpg";
                String filename2 = Server.MapPath(photoPath) + dr["ImageGuid"].ToString() + "-M.jpg";
                String filename3 = Server.MapPath(photoPath) + dr["ImageGuid"].ToString() + ".jpg";
                if (System.IO.File.Exists(filename3))
                {
                    System.IO.File.Delete(filename);
                    System.IO.File.Delete(filename1);
                    System.IO.File.Delete(filename2);
                    System.IO.File.Delete(filename3);
                }
                RobsCommonUtils.AmazonS3.DeleteFile(filename);
                RobsCommonUtils.AmazonS3.DeleteFile(filename1);
                RobsCommonUtils.AmazonS3.DeleteFile(filename2);
                RobsCommonUtils.AmazonS3.DeleteFile(filename3);

                int imageId = -1;
                int.TryParse(dr["ImageID"].ToString(), out imageId);
                bool isMainPhoto = (bool)dr["IsMainPhoto"];

                dsImages.Tables[0].Rows.Remove(dr);

                //Delete from DB
                DeletePhotoToDb(imageId, isMainPhoto);
                MakePhotoMain();


                break;
            }
        }

        this.bindDataList();

    }

    private List<PhotoData> GetUserPhotosFromDb()
    {
        var photosDataList = new List<PhotoData>();
        var userId = (int)MyUtils.GetUserField("id_user");

        DataSet userData = db.GetDataSet(string.Format("select * from users where id_user={0}", userId));
        DataSet photosData = db.GetDataSet(string.Format("select * from photos where id_user={0}", userId));

        var userPhotoId = userData.Tables[0].Rows[0]["id_photo"];

        if (photosData.Tables.Count > 0)
        {
            DataTable photosTable = photosData.Tables[0];

            for (int i = 0; i < photosTable.Rows.Count; i++)
            {
                var pd = new PhotoData
                {
                    GuidPhoto = Guid.Parse(photosTable.Rows[i]["GUID"].ToString()),
                    idPhoto = (int)photosTable.Rows[i]["id_photo"],
                    idUser = (int)photosTable.Rows[i]["id_user"],
                    isApproved = (bool)photosTable.Rows[i]["is_approved"],
                    isPrivate = (bool)photosTable.Rows[i]["is_private"],
                    isMainPhoto = !(userPhotoId is DBNull) && (int)userPhotoId == (int)photosTable.Rows[i]["id_photo"]
                };

                photosDataList.Add(pd);

            }
        }

        return photosDataList;
    }

    private int SavePhotoToDb(string guidPhoto, Tuple<int,int> imSizes)
    {
        int userId = (int)MyUtils.GetUserField("id_user");
        int newIdPhoto = 0;
        //Insert a new photo to photos table
        try
        {
            DataSet ds = db.CommandBuilder_LoadDataSet("select * from photos where id_user=-1"); //get the columns schema
            DataRow newPhoto = ds.Tables[0].NewRow();
            newPhoto["id_user"] = userId;
            newPhoto["GUID"] = guidPhoto;
            newPhoto["is_approved"] = false;
            newPhoto["is_private"] = false;
            newPhoto["image_height"] = imSizes.Item1;
            newPhoto["image_width"] = imSizes.Item2;
            ds.Tables[0].Rows.Add(newPhoto);

            newIdPhoto = db.CommandBuilder_SaveDataset(); //gets back @@identity

            foreach (DataRow dr in dsImages.Tables[0].Rows)
            {
                if (dr["ImageGuid"].ToString() == guidPhoto) dr["ImageID"] = newIdPhoto;
            }
        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }
        return newIdPhoto;
    }

    private void DeletePhotoToDb(int idPhoto, bool isMain)
    {
        try
        {
            if (isMain)
            {
                db.Execute(string.Format("update users set id_photo = null where id_user={0}", (int)MyUtils.GetUserField("id_user")));
                Session["MainPhotoGuid"] = null;
                MyUtils.RefreshUserRow();
            }
            db.Execute(string.Format("delete from photos where id_photo={0}", idPhoto));

        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }
    }

    protected void btnSetAsMainPhoto_Click(object sender, CommandEventArgs e)
    {
        MakeMainPhotoInDB(e.CommandArgument.ToString());
    }

    private void MakeMainPhotoInDB(string currentImageId)
    { 
        try
        {
            foreach (DataRow dr in dsImages.Tables[0].Rows)
            {
                dr["IsMainPhoto"] = false;

                if (dr["ImageID"].ToString() == currentImageId)
                {
                    DataSet ds = db.CommandBuilder_LoadDataSet(string.Format("select * from users where id_user={0}", (int)MyUtils.GetUserField("id_user")));
                    DataRow userRow = ds.Tables[0].Rows[0];

                    userRow["id_photo"] = dr["ImageID"];

                    db.CommandBuilder_SaveDataset();

                    MyUtils.RefreshUserRow();


                    dr["IsMainPhoto"] = true;

                    Session["MainPhotoGuid"] = dr["ImageGuid"].ToString();
                }
            }

            OrderDataList();
            bindDataList();
        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }
    }



    protected void cbxPrivate_CheckedChanged(object sender, EventArgs e)
    {
        try
        {
            foreach (DataRow dr in dsImages.Tables[0].Rows)
            {
                if (dr["ImageID"].ToString() == ((CheckBox)sender).Attributes["TagKey"].ToString())
                {
                    var idPhoto = dr["ImageId"].ToString();
                    
                    DataSet ds = db.CommandBuilder_LoadDataSet(string.Format("select * from photos where id_photo={0}", idPhoto));
                    DataRow photoRow = ds.Tables[0].Rows[0];

                    photoRow["is_private"] = ((CheckBox)sender).Checked;

                    db.CommandBuilder_SaveDataset();

                    dr["IsPrivate"] = ((CheckBox)sender).Checked;
                }
            }

            bindDataList();
        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }

    }

    private int GetPhotosCount()
    {
        return dsImages.Tables["Images"].Rows.Count;
    }

    protected string IsPrivate(bool isPrivate)
    {
        return isPrivate ? "private" : "";
    }

    protected void btnComplete_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Account/");
    }
}