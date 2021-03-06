/*USE [master]
GO
/****** Object:  Database [MedLaunch]    Script Date: 05/09/2017 20:12:19 ******/
CREATE DATABASE [MedLaunch]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MedLaunch', FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MedLaunch.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MedLaunch_log', FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MedLaunch_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MedLaunch] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MedLaunch].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MedLaunch] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MedLaunch] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MedLaunch] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MedLaunch] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MedLaunch] SET ARITHABORT OFF 
GO
ALTER DATABASE [MedLaunch] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MedLaunch] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MedLaunch] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MedLaunch] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MedLaunch] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MedLaunch] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MedLaunch] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MedLaunch] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MedLaunch] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MedLaunch] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MedLaunch] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MedLaunch] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MedLaunch] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MedLaunch] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MedLaunch] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MedLaunch] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MedLaunch] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MedLaunch] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MedLaunch] SET  MULTI_USER 
GO
ALTER DATABASE [MedLaunch] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MedLaunch] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MedLaunch] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MedLaunch] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [MedLaunch] SET DELAYED_DURABILITY = DISABLED 
GO
USE [MedLaunch]
GO
/****** Object:  Table [dbo].[discord_channels]    Script Date: 05/09/2017 20:12:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[discord_channels](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[channel_name] [varchar](20) NOT NULL,
	[channel_discord_id] [varchar](50) NOT NULL,
 CONSTRAINT [PK_discord_channels] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[discord_messages]    Script Date: 05/09/2017 20:12:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[discord_messages](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[posted_on] [datetime] NOT NULL,
	[code] [varchar](50) NOT NULL,
	[name] [varchar](32) NOT NULL,
	[message] [varchar](2000) NOT NULL,
	[channel] [int] NOT NULL,
	[clients_ignore] [bit] NOT NULL,
 CONSTRAINT [PK_discord_messages] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[discord_users]    Script Date: 05/09/2017 20:12:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[discord_users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[user_discord_id] [varchar](50) NOT NULL,
	[is_online] [bit] NOT NULL,
 CONSTRAINT [PK_discord_users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[group_members]    Script Date: 05/09/2017 20:12:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[group_members](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[group_id] [int] NOT NULL,
	[install_id] [int] NOT NULL,
	[awaiting_invite_confrim] [bit] NOT NULL,
 CONSTRAINT [PK_group_members] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[groups]    Script Date: 05/09/2017 20:12:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[group_name] [varchar](20) NOT NULL,
	[group_owner] [int] NOT NULL,
	[group_description] [varchar](200) NULL,
 CONSTRAINT [PK_groups] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[installs]    Script Date: 05/09/2017 20:12:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[installs](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[registered_on] [datetime] NOT NULL,
	[code] [varchar](50) NOT NULL,
	[banned] [bit] NOT NULL,
	[temp_ban] [bit] NOT NULL,
	[temp_ban_end] [datetime] NULL,
	[last_checkin] [datetime] NOT NULL,
	[username] [varchar](32) NOT NULL,
 CONSTRAINT [PK_installs] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[messages]    Script Date: 05/09/2017 20:12:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[messages](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[posted_on] [datetime] NOT NULL,
	[code] [varchar](50) NOT NULL,
	[name] [varchar](32) NOT NULL,
	[message] [varchar](2000) NOT NULL,
	[channel] [int] NOT NULL,
 CONSTRAINT [PK_messages] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[discord_messages]  WITH CHECK ADD  CONSTRAINT [FK_discord_messages_groups] FOREIGN KEY([channel])
REFERENCES [dbo].[discord_channels] ([id])
GO
ALTER TABLE [dbo].[discord_messages] CHECK CONSTRAINT [FK_discord_messages_groups]
GO
ALTER TABLE [dbo].[group_members]  WITH CHECK ADD  CONSTRAINT [FK_group_members_groups] FOREIGN KEY([group_id])
REFERENCES [dbo].[groups] ([id])
GO
ALTER TABLE [dbo].[group_members] CHECK CONSTRAINT [FK_group_members_groups]
GO
ALTER TABLE [dbo].[messages]  WITH CHECK ADD  CONSTRAINT [FK_messages_groups] FOREIGN KEY([channel])
REFERENCES [dbo].[groups] ([id])
GO
ALTER TABLE [dbo].[messages] CHECK CONSTRAINT [FK_messages_groups]
GO
USE [master]
GO
ALTER DATABASE [MedLaunch] SET  READ_WRITE 
GO
*/