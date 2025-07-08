using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for bl_sys_roles_access
/// </summary>
public class bl_sys_roles_access
{
    DB db = new DB();

	public bl_sys_roles_access()
	{
		//
		// TODO: Add constructor logic here
		//
      
	}
    public string RoleAccessId { get; set; }
    public string RoleId { get; set; }
    public string RoleName { get; set; }
    public string ObjectId{get;set;}
    public string ObjectName { get; set; }
    public string ObjectCode { get; set; }
    public string Module { get; set; }
    public Int32 IsView { get; set; }
    public Int32 IsAdd { get; set; }
    public Int32 IsUpdate { get; set; }
    public Int32 IsDelete { get; set; }
    public Int32 IsAdmin { get; set; }


 /// <summary>
 /// Add new system role access
 /// </summary>
 /// <param name="RoleId"></param>
 /// <param name="ObjectId"></param>
 /// <param name="IsView"></param>
 /// <param name="IsAdd"></param>
 /// <param name="IsUpdate"></param>
 /// <param name="IsApprove"></param>
 /// <param name="IsAdmin"></param>
 /// <returns></returns>
    public bool AddSysRolesAccess( string RoleId, string ObjectId, bool IsView, bool IsAdd, bool IsUpdate, bool IsDelete, bool IsAdmin)
    {
        bool result = false;
        try
        {
            result = db.Execute(AppConfiguration.GetConnectionString(), "SP_TBL_SYS_ROLES_ACCESS_ADD", new string[,] { 
            {"@role_id", RoleId},
            {"@obj_id",ObjectId},
            {"@is_view", IsView ==true ? "1" : "0"},
            {"@is_add", IsAdd==true ? "1" : "0"},
            {"@is_update",IsUpdate==true ? "1" : "0"},
            {"@IsDelete", IsDelete==true ? "1" : "0"},
            {"@is_admin", IsAdmin==true ? "1" : "0"}
            }, "bl_sys_roles_access => AddSysRolesAccess( string RoleId, string ObjectId, bool IsView, bool IsAdd, bool IsUpdate, bool IsDelete, bool IsAdmin)");
        }
        catch (Exception ex)
        {
            result = false;
            Log.AddExceptionToLog("Error function [AddSysRolesAccess( string RoleId, string ObjectId, bool IsView, bool IsAdd, bool IsUpdate, bool IsDelete, bool IsAdmin)] in class [bl_sys_roles_access], detail: " + ex.Message );
        }
        return result;
    }
    /// <summary>
    /// Update existing system role access
    /// </summary>
    /// <param name="RoleAccessId"></param>
    /// <param name="IsView"></param>
    /// <param name="IsAdd"></param>
    /// <param name="IsUpdate"></param>
    /// <param name="IsApprove"></param>
    /// <param name="IsAdmin"></param>
    /// <returns></returns>
    public bool UpdateSysRolesAccess(string RoleAccessId, bool IsView, bool IsAdd, bool IsUpdate, bool IsDelete, bool IsAdmin)
    {
        bool result = false;
        try
        {
            result = db.Execute(AppConfiguration.GetConnectionString(), "SP_TBL_SYS_ROLES_ACCESS_UPDATE", new string[,] { 
            {"@role_access_id", RoleAccessId},
            {"@obj_id",ObjectId},
            {"@is_view", IsView+""},
            {"@is_add", IsAdd+""},
            {"@is_update",IsUpdate+""},
            {"@IsDelete", IsDelete+""},
            {"@is_admin", IsAdmin+""}
            }, "bl_sys_roles_access => AUpdateSysRolesAccess(string RoleAccessId, bool IsView, bool IsAdd, bool IsUpdate, bool IsDelete, bool IsAdmin)");
        }
        catch (Exception ex)
        {
            result = false;
            Log.AddExceptionToLog("Error function [UpdateSysRolesAccess(string RoleAccessId, bool IsView, bool IsAdd, bool IsUpdate, bool IsDelete, bool IsAdmin)] in class [bl_sys_roles_access], detail: " + ex.Message );
        }
        return result;
    }

    public List<bl_sys_roles_access> GetSysRolesAccess()
    {
        List<bl_sys_roles_access> Lobj = new List<bl_sys_roles_access>();
        try
        {
            DataTable tbl = db.GetData(AppConfiguration.GetConnectionString(), "SP_TBL_SYS_ROLES_ACCESS_GET_ALL", new string[,] { }, "bl_sys_roles_access=>GetSysRolesAccess()");
            foreach (DataRow r in tbl.Rows)
            {
                Lobj.Add(new bl_sys_roles_access()
                {
                    RoleAccessId = r["id"].ToString(),
                    RoleId = r["role_id"].ToString(),
                    RoleName = r["role_name"].ToString(),
                    ObjectId = r["obj_id"].ToString(),
                    ObjectCode = r["obj_code"].ToString(),
                    ObjectName = r["obj_name"].ToString(),
                    Module=r["module"].ToString(),
                    IsView = Convert.ToInt32(r["isview"].ToString()),
                    IsAdd = Convert.ToInt32(r["isadd"].ToString()),
                    IsUpdate = Convert.ToInt32(r["isupdate"].ToString()),
                    IsDelete = Convert.ToInt32(r["isDelete"].ToString()),
                    IsAdmin = Convert.ToInt32(r["isadmin"].ToString())
                });
            }
        }
        catch (Exception ex)
        {
            Lobj = new List<bl_sys_roles_access>();
            Log.AddExceptionToLog("Error function [GetSysRolesAccess()] in class [bl_sys_roles_access], detail: " + ex.Message );
        }

        return Lobj;
    }
    /// <summary>
    /// Get system role access by role id
    /// </summary>
    /// <param name="RoleId"></param>
    /// <returns></returns>
    public List<bl_sys_roles_access> GetSysRolesAccess(string RoleId)
    {
        List<bl_sys_roles_access> Lobj = new List<bl_sys_roles_access>();
        try
        {
            DataTable tbl = db.GetData(AppConfiguration.GetConnectionString(), "SP_my_aspnet_objectinroles_get_by_roleid", new string[,] {
            {"@role_id", RoleId}
            }, "bl_sys_roles_access=>GetSysRolesAccess(string RoleId)");
            foreach (DataRow r in tbl.Rows)
            {
                Lobj.Add(new bl_sys_roles_access()
                {
                    RoleAccessId = r["id"].ToString(),
                    RoleId = r["roleid"].ToString(),
                    RoleName = r["roleName"].ToString(),
                    ObjectId = r["objectId"].ToString(),
                    ObjectCode = r["code"].ToString(),
                    ObjectName = r["objectName"].ToString(),
                    IsView = Convert.ToInt32(r["isview"].ToString()),
                    IsAdd = Convert.ToInt32(r["isadd"].ToString()),
                    IsUpdate = Convert.ToInt32(r["isupdate"].ToString()),
                    IsDelete = Convert.ToInt32(r["isdelete"].ToString()),
                    IsAdmin = Convert.ToInt32(r["isadmin"].ToString())
                });
            }
        }
        catch (Exception ex)
        {
            Lobj = new List<bl_sys_roles_access>();
            Log.AddExceptionToLog("Error function [GetSystObjects(string RoleId] in class [bl_sys_roles_access], detail: " + ex.Message );
        }

        return Lobj;
    }

    public List<bl_sys_roles_access> GetSysRolesAccessByUserName(string userName)
    {
        List<bl_sys_roles_access> Lobj = new List<bl_sys_roles_access>();
        try
        {
            DataTable tbl = db.GetData(AppConfiguration.GetConnectionString(), "SP_my_aspnet_objectinroles_get_by_userName", new string[,] {
            {"v_userName", userName}
            }, "bl_sys_roles_access=>GetSysRolesAccessByUserName(string userName)");
            foreach (DataRow r in tbl.Rows)
            {
                Lobj.Add(new bl_sys_roles_access()
                {
                    RoleAccessId = r["id"].ToString(),
                    RoleId = r["roleid"].ToString(),
                    RoleName = r["roleName"].ToString(),
                    ObjectId = r["objectId"].ToString(),
                    ObjectCode = r["code"].ToString(),
                    ObjectName = r["objectName"].ToString(),
                    IsView = Convert.ToInt32(r["isview"].ToString()),
                    IsAdd = Convert.ToInt32(r["isadd"].ToString()),
                    IsUpdate = Convert.ToInt32(r["isupdate"].ToString()),
                    IsDelete = Convert.ToInt32(r["isdelete"].ToString()),
                    IsAdmin = Convert.ToInt32(r["isadmin"].ToString())
                });
            }
        }
        catch (Exception ex)
        {
            Lobj = new List<bl_sys_roles_access>();
            Log.AddExceptionToLog("Error function [GetSysRolesAccessByUserName(string userName)] in class [bl_sys_roles_access], detail: " + ex.Message);
        }

        return Lobj;
    }

    public bl_sys_roles_access GetSysRolesAccess(string userName, string objeceCode)
    {
        bl_sys_roles_access obj = new bl_sys_roles_access();
        try
        {
            var accesslist = GetSysRolesAccessByUserName(userName);
            foreach (bl_sys_roles_access var in accesslist.Where(_ => _.ObjectCode == objeceCode))
            {
                obj = var;
                break;
            }
        }
        catch (Exception ex)
        {
            obj = null;
            Log.AddExceptionToLog("Error function [GetSysRolesAccess(string userName, string objeceCode)] in class [bl_sys_roles_access], detail: " + ex.Message);
        }
        return obj;
    }

    public List<string> GetRoleId(string userName)
    {
        List<string> rId = new List<string>();


        return rId;
        
    }

    public List<bl_sys_roles_access> GetSysRolesAccess(string RoleId, string RoleName, string Module)
    {
        List<bl_sys_roles_access> Lobj = new List<bl_sys_roles_access>();
        try
        {
            DataTable tbl = db.GetData(AppConfiguration.GetConnectionString(), "SP_TBL_SYS_ROLES_ACCESS_GET_BY_COND", new string[,] {
            {"@role_id",  "%" + RoleId+"%"},{"@module",  "%"+ Module+"%" }, {"@role_name", "%"+RoleName+"%"}
            }, "bl_sys_roles_access=>GetSysRolesAccess(string RoleId, string Module)");
            foreach (DataRow r in tbl.Rows)
            {
                Lobj.Add(new bl_sys_roles_access()
                {
                    RoleAccessId = r["id"].ToString(),
                    RoleId = r["roleid"].ToString(),
                    RoleName = r["rolename"].ToString(),
                    ObjectId = r["objectid"].ToString(),
                    ObjectCode = r["code"].ToString(),
                    ObjectName = r["objectname"].ToString(),
                    Module = r["Module"].ToString(),
                    IsView = Convert.ToInt32(r["isview"].ToString()),
                    IsAdd = Convert.ToInt32(r["isadd"].ToString()),
                    IsUpdate = Convert.ToInt32(r["isupdate"].ToString()),
                    IsDelete = Convert.ToInt32(r["isdelete"].ToString()),
                    IsAdmin = Convert.ToInt32(r["isadmin"].ToString())
                });
            }
        }
        catch (Exception ex)
        {
            Lobj = new List<bl_sys_roles_access>();
            Log.AddExceptionToLog("Error function [GetSystObjects(string RoleId, string Module] in class [bl_sys_roles_access], detail: " + ex.Message );
        }

        return Lobj;
    }
    /// <summary>
    /// Delete System Roles Access by Role Id and Module
    /// </summary>
    /// <param name="RoleId"></param>
    /// <param name="Module"></param>
    /// <returns></returns>
    public bool DeleteSysRolesAccess(string RoleId, string Module)
    {
        bool result = false;
        try
        {
            result = db.Execute(AppConfiguration.GetConnectionString(), "SP_TBL_SYS_ROLES_ACCESS_DELETE_BY_MODULE", new string[,] { 
            {"@role_id", RoleId},
            {"@module",Module},
           
            }, "bl_sys_roles_access => DeleteSysRolesAccess(string RoleId, string Module)");
        }
        catch (Exception ex)
        {
            result = false;
            Log.AddExceptionToLog("Error function [DeleteSysRolesAccess(string RoleId, string Module)] in class [bl_sys_roles_access], detail: " + ex.Message );
        }
        return result;
    }
}