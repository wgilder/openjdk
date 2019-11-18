USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', 
                          N'Software\Microsoft\MSSQLServer\MSSQLServer',      
                          N'LoginMode', REG_DWORD, 2
GO
CREATE LOGIN UIPATH WITH PASSWORD = 'CuddleB3@r'
GO
CREATE USER UIPATH FOR LOGIN UIPATH
GO
