namespace VaultMetaDataManager
{
    partial class Frm_Main
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Frm_Main));
            this.tab_Main = new System.Windows.Forms.TabControl();
            this.tabpg_Connection = new System.Windows.Forms.TabPage();
            this.grp_Connection = new System.Windows.Forms.GroupBox();
            this.lbl_Server = new System.Windows.Forms.Label();
            this.lbl_ServerName = new System.Windows.Forms.Label();
            this.btn_Start = new System.Windows.Forms.Button();
            this.txt_ServerName = new System.Windows.Forms.TextBox();
            this.cmb_Database = new System.Windows.Forms.ComboBox();
            this.btn_Connect = new System.Windows.Forms.Button();
            this.lbl_Database = new System.Windows.Forms.Label();
            this.lbl_Authentication = new System.Windows.Forms.Label();
            this.txt_Password = new System.Windows.Forms.TextBox();
            this.cmb_Authentication = new System.Windows.Forms.ComboBox();
            this.txt_UserName = new System.Windows.Forms.TextBox();
            this.lbl_UserName = new System.Windows.Forms.Label();
            this.lbl_Password = new System.Windows.Forms.Label();
            this.tabpg_Configuration = new System.Windows.Forms.TabPage();
            this.grp_Configuration = new System.Windows.Forms.GroupBox();
            this.dgv_configuration = new System.Windows.Forms.DataGridView();
            this.Configuration_Id = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Configuration_Value = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Description = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.configurationBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.DVMeta_Entity = new VaultMetaDataManager.DVMeta_Entity();
            this.btn_SaveConfiguration = new System.Windows.Forms.Button();
            this.grp_ConfigValidation = new System.Windows.Forms.GroupBox();
            this.dgv_ValidateConfig = new System.Windows.Forms.DataGridView();
            this.ruleIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ruleCategoryDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ruleNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.reasonDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.configurationIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.configurationValueDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.validateConfigurationBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.tabpg_Entities = new System.Windows.Forms.TabPage();
            this.grp_Entity = new System.Windows.Forms.GroupBox();
            this.btn_DeleteEntity = new System.Windows.Forms.Button();
            this.btn_SaveEntity = new System.Windows.Forms.Button();
            this.dgv_Entity = new System.Windows.Forms.DataGridView();
            this.EntityId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.EntityName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.EntityDescription = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Entity_EntityTypeId = new System.Windows.Forms.DataGridViewComboBoxColumn();
            this.entityTypeBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.Entity_StorageTypeId = new System.Windows.Forms.DataGridViewComboBoxColumn();
            this.storageTypeBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.Entity_PartitioningTypeId = new System.Windows.Forms.DataGridViewComboBoxColumn();
            this.partitioningTypeBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.CreateEntity = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Entity_LastUpdateTime = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.eDWEntityBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.grp_Attribute = new System.Windows.Forms.GroupBox();
            this.btn_SaveAttribute = new System.Windows.Forms.Button();
            this.btn_DeleteAttribute = new System.Windows.Forms.Button();
            this.dgv_Attribute = new System.Windows.Forms.DataGridView();
            this.AttributeId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.AttributeName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Attribute_EntityId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Attribute_DataTypeId = new System.Windows.Forms.DataGridViewComboBoxColumn();
            this.dataTypeBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.Order = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.IsStagingOnly = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Attribute_LastUpdateTime = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Attribute_LastChangeUserName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.eDWAttributeBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.tabpg_Relationships = new System.Windows.Forms.TabPage();
            this.grp_EntityRelationship = new System.Windows.Forms.GroupBox();
            this.btn_DeleteRelationship = new System.Windows.Forms.Button();
            this.dgv_EntityRelationship = new System.Windows.Forms.DataGridView();
            this.EntityRelationshipId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.hashKeySuffixDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.eDWEntityRelationshipExtendedBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.grp_EntityParent = new System.Windows.Forms.GroupBox();
            this.btn_SaveRelationship = new System.Windows.Forms.Button();
            this.lbl_HashKeySuffix = new System.Windows.Forms.Label();
            this.lbl_RelatedTo = new System.Windows.Forms.Label();
            this.lbl_HubLnk = new System.Windows.Forms.Label();
            this.txt_HashKeySuffix = new System.Windows.Forms.TextBox();
            this.dgv_UsedBy = new System.Windows.Forms.DataGridView();
            this.UsedBy_EntityId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.UsedBy_EntityTypeId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.UsedBy_EntityName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dgv_HubOrLnk = new System.Windows.Forms.DataGridView();
            this.HubOrLnk_EntityId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.HubOrLnk_EntityTypeId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.HubOrLnk_EntityName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.tabpg_Processes = new System.Windows.Forms.TabPage();
            this.grp_Process = new System.Windows.Forms.GroupBox();
            this.btn_DeleteProcess = new System.Windows.Forms.Button();
            this.btn_SaveProcess = new System.Windows.Forms.Button();
            this.dgv_Process = new System.Windows.Forms.DataGridView();
            this.ProcessId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ProcessName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ProcessDescription = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ProcessTypeId = new System.Windows.Forms.DataGridViewComboBoxColumn();
            this.processTypeBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.SourceSystemTypeId = new System.Windows.Forms.DataGridViewComboBoxColumn();
            this.sourceSystemTypeBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.ContactInfo = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.SupportGroup = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn5 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.processBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.grp_ProcessEntity = new System.Windows.Forms.GroupBox();
            this.chk_ExcludeOtherProcess = new System.Windows.Forms.CheckBox();
            this.btn_SaveProcessEntity = new System.Windows.Forms.Button();
            this.dgv_ProcessEntity = new System.Windows.Forms.DataGridView();
            this.IsRelated = new System.Windows.Forms.DataGridViewCheckBoxColumn();
            this.ProcessEntity_EntityId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ProcessEntity_EntityTypeId = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ProcessEntity_EntityName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.eDWEntityExtendedBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.tabpg_Deployment = new System.Windows.Forms.TabPage();
            this.grp_Result = new System.Windows.Forms.GroupBox();
            this.lbl_DeployResult = new System.Windows.Forms.Label();
            this.btn_DeployModel = new System.Windows.Forms.Button();
            this.tab_Validation = new System.Windows.Forms.TabControl();
            this.tabpg_Validation = new System.Windows.Forms.TabPage();
            this.dgv_ValidateModel = new System.Windows.Forms.DataGridView();
            this.ruleIdDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ruleCategoryDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ruleNameDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.reasonDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.entityIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.entityTypeNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.entityNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.validateModelBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.tabpg_Result = new System.Windows.Forms.TabPage();
            this.txt_DeployMessage = new System.Windows.Forms.TextBox();
            this.eDWEntityRelationshipBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.processEntityRelationshipBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.storageTypeTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.StorageTypeTableAdapter();
            this.entityTypeTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.EntityTypeTableAdapter();
            this.partitioningTypeTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.PartitioningTypeTableAdapter();
            this.eDWAttributeTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.EDWAttributeTableAdapter();
            this.eDWEntityTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.EDWEntityTableAdapter();
            this.dataTypeTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.DataTypeTableAdapter();
            this.validateConfigurationTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.ValidateConfigurationTableAdapter();
            this.configurationTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.ConfigurationTableAdapter();
            this.processTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.ProcessTableAdapter();
            this.processEntityRelationshipTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.ProcessEntityRelationshipTableAdapter();
            this.processTypeTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.ProcessTypeTableAdapter();
            this.sourceSystemTypeTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.SourceSystemTypeTableAdapter();
            this.eDWEntityExtendedTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.EDWEntityExtendedTableAdapter();
            this.eDWEntityRelationshipTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.EDWEntityRelationshipTableAdapter();
            this.eDWEntityRelationshipExtendedTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.EDWEntityRelationshipExtendedTableAdapter();
            this.validateModelTableAdapter = new VaultMetaDataManager.DVMeta_EntityTableAdapters.ValidateModelTableAdapter();
            this.sts_Status = new System.Windows.Forms.StatusStrip();
            this.toolsts_Connection = new System.Windows.Forms.ToolStripStatusLabel();
            this.tab_Main.SuspendLayout();
            this.tabpg_Connection.SuspendLayout();
            this.grp_Connection.SuspendLayout();
            this.tabpg_Configuration.SuspendLayout();
            this.grp_Configuration.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_configuration)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.configurationBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.DVMeta_Entity)).BeginInit();
            this.grp_ConfigValidation.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ValidateConfig)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.validateConfigurationBindingSource)).BeginInit();
            this.tabpg_Entities.SuspendLayout();
            this.grp_Entity.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Entity)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.entityTypeBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.storageTypeBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.partitioningTypeBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.eDWEntityBindingSource)).BeginInit();
            this.grp_Attribute.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Attribute)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataTypeBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.eDWAttributeBindingSource)).BeginInit();
            this.tabpg_Relationships.SuspendLayout();
            this.grp_EntityRelationship.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_EntityRelationship)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.eDWEntityRelationshipExtendedBindingSource)).BeginInit();
            this.grp_EntityParent.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_UsedBy)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_HubOrLnk)).BeginInit();
            this.tabpg_Processes.SuspendLayout();
            this.grp_Process.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Process)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.processTypeBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.sourceSystemTypeBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.processBindingSource)).BeginInit();
            this.grp_ProcessEntity.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ProcessEntity)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.eDWEntityExtendedBindingSource)).BeginInit();
            this.tabpg_Deployment.SuspendLayout();
            this.grp_Result.SuspendLayout();
            this.tab_Validation.SuspendLayout();
            this.tabpg_Validation.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ValidateModel)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.validateModelBindingSource)).BeginInit();
            this.tabpg_Result.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.eDWEntityRelationshipBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.processEntityRelationshipBindingSource)).BeginInit();
            this.sts_Status.SuspendLayout();
            this.SuspendLayout();
            // 
            // tab_Main
            // 
            this.tab_Main.Controls.Add(this.tabpg_Connection);
            this.tab_Main.Controls.Add(this.tabpg_Configuration);
            this.tab_Main.Controls.Add(this.tabpg_Entities);
            this.tab_Main.Controls.Add(this.tabpg_Relationships);
            this.tab_Main.Controls.Add(this.tabpg_Processes);
            this.tab_Main.Controls.Add(this.tabpg_Deployment);
            this.tab_Main.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tab_Main.Location = new System.Drawing.Point(0, 0);
            this.tab_Main.Margin = new System.Windows.Forms.Padding(4);
            this.tab_Main.Name = "tab_Main";
            this.tab_Main.SelectedIndex = 0;
            this.tab_Main.Size = new System.Drawing.Size(1344, 878);
            this.tab_Main.TabIndex = 0;
            this.tab_Main.SelectedIndexChanged += new System.EventHandler(this.tab_Main_SelectedIndexChanged);
            // 
            // tabpg_Connection
            // 
            this.tabpg_Connection.Controls.Add(this.grp_Connection);
            this.tabpg_Connection.Location = new System.Drawing.Point(4, 25);
            this.tabpg_Connection.Margin = new System.Windows.Forms.Padding(4);
            this.tabpg_Connection.Name = "tabpg_Connection";
            this.tabpg_Connection.Padding = new System.Windows.Forms.Padding(4);
            this.tabpg_Connection.Size = new System.Drawing.Size(1336, 849);
            this.tabpg_Connection.TabIndex = 5;
            this.tabpg_Connection.Text = "Connection";
            this.tabpg_Connection.UseVisualStyleBackColor = true;
            // 
            // grp_Connection
            // 
            this.grp_Connection.Controls.Add(this.lbl_Server);
            this.grp_Connection.Controls.Add(this.lbl_ServerName);
            this.grp_Connection.Controls.Add(this.btn_Start);
            this.grp_Connection.Controls.Add(this.txt_ServerName);
            this.grp_Connection.Controls.Add(this.cmb_Database);
            this.grp_Connection.Controls.Add(this.btn_Connect);
            this.grp_Connection.Controls.Add(this.lbl_Database);
            this.grp_Connection.Controls.Add(this.lbl_Authentication);
            this.grp_Connection.Controls.Add(this.txt_Password);
            this.grp_Connection.Controls.Add(this.cmb_Authentication);
            this.grp_Connection.Controls.Add(this.txt_UserName);
            this.grp_Connection.Controls.Add(this.lbl_UserName);
            this.grp_Connection.Controls.Add(this.lbl_Password);
            this.grp_Connection.Location = new System.Drawing.Point(345, 164);
            this.grp_Connection.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grp_Connection.Name = "grp_Connection";
            this.grp_Connection.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grp_Connection.Size = new System.Drawing.Size(637, 341);
            this.grp_Connection.TabIndex = 12;
            this.grp_Connection.TabStop = false;
            this.grp_Connection.Text = "Connect";
            // 
            // lbl_Server
            // 
            this.lbl_Server.AutoSize = true;
            this.lbl_Server.Location = new System.Drawing.Point(437, 142);
            this.lbl_Server.Name = "lbl_Server";
            this.lbl_Server.Size = new System.Drawing.Size(0, 17);
            this.lbl_Server.TabIndex = 12;
            // 
            // lbl_ServerName
            // 
            this.lbl_ServerName.AutoSize = true;
            this.lbl_ServerName.Location = new System.Drawing.Point(55, 74);
            this.lbl_ServerName.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbl_ServerName.Name = "lbl_ServerName";
            this.lbl_ServerName.Size = new System.Drawing.Size(121, 17);
            this.lbl_ServerName.TabIndex = 0;
            this.lbl_ServerName.Text = "SQL Server name";
            // 
            // btn_Start
            // 
            this.btn_Start.Enabled = false;
            this.btn_Start.Location = new System.Drawing.Point(437, 241);
            this.btn_Start.Margin = new System.Windows.Forms.Padding(4);
            this.btn_Start.Name = "btn_Start";
            this.btn_Start.Size = new System.Drawing.Size(100, 28);
            this.btn_Start.TabIndex = 11;
            this.btn_Start.Text = "Start";
            this.btn_Start.UseVisualStyleBackColor = true;
            this.btn_Start.Click += new System.EventHandler(this.btn_Start_Click);
            // 
            // txt_ServerName
            // 
            this.txt_ServerName.Location = new System.Drawing.Point(196, 70);
            this.txt_ServerName.Margin = new System.Windows.Forms.Padding(4);
            this.txt_ServerName.Name = "txt_ServerName";
            this.txt_ServerName.Size = new System.Drawing.Size(215, 22);
            this.txt_ServerName.TabIndex = 1;
            // 
            // cmb_Database
            // 
            this.cmb_Database.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmb_Database.Enabled = false;
            this.cmb_Database.FormattingEnabled = true;
            this.cmb_Database.Location = new System.Drawing.Point(196, 242);
            this.cmb_Database.Margin = new System.Windows.Forms.Padding(4);
            this.cmb_Database.Name = "cmb_Database";
            this.cmb_Database.Size = new System.Drawing.Size(215, 24);
            this.cmb_Database.TabIndex = 10;
            this.cmb_Database.SelectedIndexChanged += new System.EventHandler(this.cmb_Database_SelectedIndexChanged);
            // 
            // btn_Connect
            // 
            this.btn_Connect.Location = new System.Drawing.Point(437, 110);
            this.btn_Connect.Margin = new System.Windows.Forms.Padding(4);
            this.btn_Connect.Name = "btn_Connect";
            this.btn_Connect.Size = new System.Drawing.Size(100, 28);
            this.btn_Connect.TabIndex = 2;
            this.btn_Connect.Text = "Connect";
            this.btn_Connect.UseVisualStyleBackColor = true;
            this.btn_Connect.Click += new System.EventHandler(this.btn_Connect_Click);
            // 
            // lbl_Database
            // 
            this.lbl_Database.AutoSize = true;
            this.lbl_Database.Location = new System.Drawing.Point(55, 247);
            this.lbl_Database.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbl_Database.Name = "lbl_Database";
            this.lbl_Database.Size = new System.Drawing.Size(69, 17);
            this.lbl_Database.TabIndex = 9;
            this.lbl_Database.Text = "Database";
            // 
            // lbl_Authentication
            // 
            this.lbl_Authentication.AutoSize = true;
            this.lbl_Authentication.Location = new System.Drawing.Point(55, 114);
            this.lbl_Authentication.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbl_Authentication.Name = "lbl_Authentication";
            this.lbl_Authentication.Size = new System.Drawing.Size(98, 17);
            this.lbl_Authentication.TabIndex = 3;
            this.lbl_Authentication.Text = "Authentication";
            // 
            // txt_Password
            // 
            this.txt_Password.Location = new System.Drawing.Point(196, 198);
            this.txt_Password.Margin = new System.Windows.Forms.Padding(4);
            this.txt_Password.Name = "txt_Password";
            this.txt_Password.Size = new System.Drawing.Size(215, 22);
            this.txt_Password.TabIndex = 8;
            this.txt_Password.UseSystemPasswordChar = true;
            // 
            // cmb_Authentication
            // 
            this.cmb_Authentication.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmb_Authentication.FormattingEnabled = true;
            this.cmb_Authentication.Items.AddRange(new object[] {
            "Windows Authentication",
            "SQL Server Authentication"});
            this.cmb_Authentication.Location = new System.Drawing.Point(196, 111);
            this.cmb_Authentication.Margin = new System.Windows.Forms.Padding(4);
            this.cmb_Authentication.Name = "cmb_Authentication";
            this.cmb_Authentication.Size = new System.Drawing.Size(215, 24);
            this.cmb_Authentication.TabIndex = 4;
            this.cmb_Authentication.SelectedIndexChanged += new System.EventHandler(this.cmb_Authentication_SelectedIndexChanged);
            // 
            // txt_UserName
            // 
            this.txt_UserName.Location = new System.Drawing.Point(196, 155);
            this.txt_UserName.Margin = new System.Windows.Forms.Padding(4);
            this.txt_UserName.Name = "txt_UserName";
            this.txt_UserName.Size = new System.Drawing.Size(215, 22);
            this.txt_UserName.TabIndex = 7;
            // 
            // lbl_UserName
            // 
            this.lbl_UserName.AutoSize = true;
            this.lbl_UserName.Location = new System.Drawing.Point(55, 158);
            this.lbl_UserName.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbl_UserName.Name = "lbl_UserName";
            this.lbl_UserName.Size = new System.Drawing.Size(77, 17);
            this.lbl_UserName.TabIndex = 5;
            this.lbl_UserName.Text = "User name";
            // 
            // lbl_Password
            // 
            this.lbl_Password.AutoSize = true;
            this.lbl_Password.Location = new System.Drawing.Point(55, 202);
            this.lbl_Password.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbl_Password.Name = "lbl_Password";
            this.lbl_Password.Size = new System.Drawing.Size(69, 17);
            this.lbl_Password.TabIndex = 6;
            this.lbl_Password.Text = "Password";
            // 
            // tabpg_Configuration
            // 
            this.tabpg_Configuration.Controls.Add(this.grp_Configuration);
            this.tabpg_Configuration.Controls.Add(this.grp_ConfigValidation);
            this.tabpg_Configuration.Location = new System.Drawing.Point(4, 25);
            this.tabpg_Configuration.Margin = new System.Windows.Forms.Padding(4);
            this.tabpg_Configuration.Name = "tabpg_Configuration";
            this.tabpg_Configuration.Padding = new System.Windows.Forms.Padding(4);
            this.tabpg_Configuration.Size = new System.Drawing.Size(1336, 849);
            this.tabpg_Configuration.TabIndex = 0;
            this.tabpg_Configuration.Text = "Configuration";
            this.tabpg_Configuration.UseVisualStyleBackColor = true;
            // 
            // grp_Configuration
            // 
            this.grp_Configuration.Controls.Add(this.dgv_configuration);
            this.grp_Configuration.Controls.Add(this.btn_SaveConfiguration);
            this.grp_Configuration.Dock = System.Windows.Forms.DockStyle.Top;
            this.grp_Configuration.Location = new System.Drawing.Point(4, 4);
            this.grp_Configuration.Margin = new System.Windows.Forms.Padding(4);
            this.grp_Configuration.Name = "grp_Configuration";
            this.grp_Configuration.Padding = new System.Windows.Forms.Padding(4);
            this.grp_Configuration.Size = new System.Drawing.Size(1328, 468);
            this.grp_Configuration.TabIndex = 4;
            this.grp_Configuration.TabStop = false;
            this.grp_Configuration.Text = "Configuration";
            // 
            // dgv_configuration
            // 
            this.dgv_configuration.AllowUserToAddRows = false;
            this.dgv_configuration.AllowUserToDeleteRows = false;
            this.dgv_configuration.AllowUserToOrderColumns = true;
            this.dgv_configuration.AutoGenerateColumns = false;
            this.dgv_configuration.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_configuration.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Configuration_Id,
            this.Configuration_Value,
            this.Description});
            this.dgv_configuration.DataSource = this.configurationBindingSource;
            this.dgv_configuration.Dock = System.Windows.Forms.DockStyle.Top;
            this.dgv_configuration.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgv_configuration.Location = new System.Drawing.Point(4, 19);
            this.dgv_configuration.Margin = new System.Windows.Forms.Padding(4);
            this.dgv_configuration.Name = "dgv_configuration";
            this.dgv_configuration.RowHeadersVisible = false;
            this.dgv_configuration.Size = new System.Drawing.Size(1320, 405);
            this.dgv_configuration.TabIndex = 0;
            this.dgv_configuration.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Configuration_CellValueChanged);
            this.dgv_configuration.DataBindingComplete += new System.Windows.Forms.DataGridViewBindingCompleteEventHandler(this.dgv_Configuration_DataBindingComplete);
            this.dgv_configuration.DataError += new System.Windows.Forms.DataGridViewDataErrorEventHandler(this.dgv_Configuration_DataError);
            // 
            // Configuration_Id
            // 
            this.Configuration_Id.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells;
            this.Configuration_Id.DataPropertyName = "Id";
            this.Configuration_Id.HeaderText = "ConfigurationId";
            this.Configuration_Id.Name = "Configuration_Id";
            this.Configuration_Id.ReadOnly = true;
            this.Configuration_Id.Width = 132;
            // 
            // Configuration_Value
            // 
            this.Configuration_Value.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Configuration_Value.DataPropertyName = "Value";
            this.Configuration_Value.HeaderText = "Value";
            this.Configuration_Value.Name = "Configuration_Value";
            // 
            // Description
            // 
            this.Description.DataPropertyName = "Description";
            this.Description.HeaderText = "Description";
            this.Description.Name = "Description";
            this.Description.ReadOnly = true;
            this.Description.Visible = false;
            // 
            // configurationBindingSource
            // 
            this.configurationBindingSource.DataMember = "Configuration";
            this.configurationBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // DVMeta_Entity
            // 
            this.DVMeta_Entity.DataSetName = "DVMeta_Entity";
            this.DVMeta_Entity.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // btn_SaveConfiguration
            // 
            this.btn_SaveConfiguration.Enabled = false;
            this.btn_SaveConfiguration.Location = new System.Drawing.Point(4, 432);
            this.btn_SaveConfiguration.Margin = new System.Windows.Forms.Padding(4);
            this.btn_SaveConfiguration.Name = "btn_SaveConfiguration";
            this.btn_SaveConfiguration.Size = new System.Drawing.Size(149, 28);
            this.btn_SaveConfiguration.TabIndex = 2;
            this.btn_SaveConfiguration.Text = "Save Configuration";
            this.btn_SaveConfiguration.UseVisualStyleBackColor = true;
            this.btn_SaveConfiguration.Click += new System.EventHandler(this.btn_SaveConfiguration_Click);
            // 
            // grp_ConfigValidation
            // 
            this.grp_ConfigValidation.Controls.Add(this.dgv_ValidateConfig);
            this.grp_ConfigValidation.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.grp_ConfigValidation.Location = new System.Drawing.Point(4, 504);
            this.grp_ConfigValidation.Margin = new System.Windows.Forms.Padding(4);
            this.grp_ConfigValidation.Name = "grp_ConfigValidation";
            this.grp_ConfigValidation.Padding = new System.Windows.Forms.Padding(4);
            this.grp_ConfigValidation.Size = new System.Drawing.Size(1328, 341);
            this.grp_ConfigValidation.TabIndex = 3;
            this.grp_ConfigValidation.TabStop = false;
            this.grp_ConfigValidation.Text = "Validation";
            // 
            // dgv_ValidateConfig
            // 
            this.dgv_ValidateConfig.AllowUserToAddRows = false;
            this.dgv_ValidateConfig.AllowUserToDeleteRows = false;
            this.dgv_ValidateConfig.AutoGenerateColumns = false;
            this.dgv_ValidateConfig.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.dgv_ValidateConfig.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_ValidateConfig.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.ruleIdDataGridViewTextBoxColumn,
            this.ruleCategoryDataGridViewTextBoxColumn,
            this.ruleNameDataGridViewTextBoxColumn,
            this.reasonDataGridViewTextBoxColumn,
            this.configurationIdDataGridViewTextBoxColumn,
            this.configurationValueDataGridViewTextBoxColumn});
            this.dgv_ValidateConfig.DataSource = this.validateConfigurationBindingSource;
            this.dgv_ValidateConfig.Dock = System.Windows.Forms.DockStyle.Top;
            this.dgv_ValidateConfig.Location = new System.Drawing.Point(4, 19);
            this.dgv_ValidateConfig.Margin = new System.Windows.Forms.Padding(4);
            this.dgv_ValidateConfig.Name = "dgv_ValidateConfig";
            this.dgv_ValidateConfig.ReadOnly = true;
            this.dgv_ValidateConfig.RowHeadersVisible = false;
            this.dgv_ValidateConfig.Size = new System.Drawing.Size(1320, 299);
            this.dgv_ValidateConfig.TabIndex = 0;
            // 
            // ruleIdDataGridViewTextBoxColumn
            // 
            this.ruleIdDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ruleIdDataGridViewTextBoxColumn.DataPropertyName = "RuleId";
            this.ruleIdDataGridViewTextBoxColumn.HeaderText = "RuleId";
            this.ruleIdDataGridViewTextBoxColumn.Name = "ruleIdDataGridViewTextBoxColumn";
            this.ruleIdDataGridViewTextBoxColumn.ReadOnly = true;
            this.ruleIdDataGridViewTextBoxColumn.Width = 65;
            // 
            // ruleCategoryDataGridViewTextBoxColumn
            // 
            this.ruleCategoryDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ruleCategoryDataGridViewTextBoxColumn.DataPropertyName = "RuleCategory";
            this.ruleCategoryDataGridViewTextBoxColumn.HeaderText = "RuleCategory";
            this.ruleCategoryDataGridViewTextBoxColumn.Name = "ruleCategoryDataGridViewTextBoxColumn";
            this.ruleCategoryDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // ruleNameDataGridViewTextBoxColumn
            // 
            this.ruleNameDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ruleNameDataGridViewTextBoxColumn.DataPropertyName = "RuleName";
            this.ruleNameDataGridViewTextBoxColumn.HeaderText = "RuleName";
            this.ruleNameDataGridViewTextBoxColumn.Name = "ruleNameDataGridViewTextBoxColumn";
            this.ruleNameDataGridViewTextBoxColumn.ReadOnly = true;
            this.ruleNameDataGridViewTextBoxColumn.Width = 150;
            // 
            // reasonDataGridViewTextBoxColumn
            // 
            this.reasonDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.reasonDataGridViewTextBoxColumn.DataPropertyName = "Reason";
            this.reasonDataGridViewTextBoxColumn.HeaderText = "Reason";
            this.reasonDataGridViewTextBoxColumn.Name = "reasonDataGridViewTextBoxColumn";
            this.reasonDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // configurationIdDataGridViewTextBoxColumn
            // 
            this.configurationIdDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.configurationIdDataGridViewTextBoxColumn.DataPropertyName = "ConfigurationId";
            this.configurationIdDataGridViewTextBoxColumn.HeaderText = "ConfigurationId";
            this.configurationIdDataGridViewTextBoxColumn.Name = "configurationIdDataGridViewTextBoxColumn";
            this.configurationIdDataGridViewTextBoxColumn.ReadOnly = true;
            this.configurationIdDataGridViewTextBoxColumn.Width = 150;
            // 
            // configurationValueDataGridViewTextBoxColumn
            // 
            this.configurationValueDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.configurationValueDataGridViewTextBoxColumn.DataPropertyName = "ConfigurationValue";
            this.configurationValueDataGridViewTextBoxColumn.HeaderText = "ConfigurationValue";
            this.configurationValueDataGridViewTextBoxColumn.Name = "configurationValueDataGridViewTextBoxColumn";
            this.configurationValueDataGridViewTextBoxColumn.ReadOnly = true;
            this.configurationValueDataGridViewTextBoxColumn.Width = 150;
            // 
            // validateConfigurationBindingSource
            // 
            this.validateConfigurationBindingSource.DataMember = "ValidateConfiguration";
            this.validateConfigurationBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // tabpg_Entities
            // 
            this.tabpg_Entities.Controls.Add(this.grp_Entity);
            this.tabpg_Entities.Controls.Add(this.grp_Attribute);
            this.tabpg_Entities.Location = new System.Drawing.Point(4, 25);
            this.tabpg_Entities.Margin = new System.Windows.Forms.Padding(4);
            this.tabpg_Entities.Name = "tabpg_Entities";
            this.tabpg_Entities.Padding = new System.Windows.Forms.Padding(4);
            this.tabpg_Entities.Size = new System.Drawing.Size(1336, 849);
            this.tabpg_Entities.TabIndex = 1;
            this.tabpg_Entities.Text = "DV Entities";
            this.tabpg_Entities.UseVisualStyleBackColor = true;
            // 
            // grp_Entity
            // 
            this.grp_Entity.Controls.Add(this.btn_DeleteEntity);
            this.grp_Entity.Controls.Add(this.btn_SaveEntity);
            this.grp_Entity.Controls.Add(this.dgv_Entity);
            this.grp_Entity.Dock = System.Windows.Forms.DockStyle.Top;
            this.grp_Entity.Location = new System.Drawing.Point(4, 4);
            this.grp_Entity.Margin = new System.Windows.Forms.Padding(4);
            this.grp_Entity.Name = "grp_Entity";
            this.grp_Entity.Padding = new System.Windows.Forms.Padding(4);
            this.grp_Entity.Size = new System.Drawing.Size(1328, 398);
            this.grp_Entity.TabIndex = 2;
            this.grp_Entity.TabStop = false;
            this.grp_Entity.Text = "Entities";
            // 
            // btn_DeleteEntity
            // 
            this.btn_DeleteEntity.Enabled = false;
            this.btn_DeleteEntity.Location = new System.Drawing.Point(4, 361);
            this.btn_DeleteEntity.Margin = new System.Windows.Forms.Padding(4);
            this.btn_DeleteEntity.Name = "btn_DeleteEntity";
            this.btn_DeleteEntity.Size = new System.Drawing.Size(188, 28);
            this.btn_DeleteEntity.TabIndex = 4;
            this.btn_DeleteEntity.Text = "Delete Selected Entities";
            this.btn_DeleteEntity.UseVisualStyleBackColor = true;
            this.btn_DeleteEntity.Click += new System.EventHandler(this.btn_DeleteEntity_Click);
            // 
            // btn_SaveEntity
            // 
            this.btn_SaveEntity.Enabled = false;
            this.btn_SaveEntity.Location = new System.Drawing.Point(227, 361);
            this.btn_SaveEntity.Margin = new System.Windows.Forms.Padding(4);
            this.btn_SaveEntity.Name = "btn_SaveEntity";
            this.btn_SaveEntity.Size = new System.Drawing.Size(121, 28);
            this.btn_SaveEntity.TabIndex = 3;
            this.btn_SaveEntity.Text = "Save Entities";
            this.btn_SaveEntity.UseVisualStyleBackColor = true;
            this.btn_SaveEntity.Click += new System.EventHandler(this.btn_SaveEntity_Click);
            // 
            // dgv_Entity
            // 
            this.dgv_Entity.AllowUserToDeleteRows = false;
            this.dgv_Entity.AllowUserToOrderColumns = true;
            this.dgv_Entity.AutoGenerateColumns = false;
            this.dgv_Entity.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.dgv_Entity.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_Entity.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.EntityId,
            this.EntityName,
            this.EntityDescription,
            this.Entity_EntityTypeId,
            this.Entity_StorageTypeId,
            this.Entity_PartitioningTypeId,
            this.CreateEntity,
            this.Entity_LastUpdateTime});
            this.dgv_Entity.DataSource = this.eDWEntityBindingSource;
            this.dgv_Entity.Dock = System.Windows.Forms.DockStyle.Top;
            this.dgv_Entity.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgv_Entity.Location = new System.Drawing.Point(4, 19);
            this.dgv_Entity.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.dgv_Entity.Name = "dgv_Entity";
            this.dgv_Entity.RowTemplate.Height = 24;
            this.dgv_Entity.Size = new System.Drawing.Size(1320, 335);
            this.dgv_Entity.TabIndex = 0;
            this.dgv_Entity.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Entity_CellValueChanged);
            this.dgv_Entity.DataError += new System.Windows.Forms.DataGridViewDataErrorEventHandler(this.dgv_Entity_DataError);
            this.dgv_Entity.RowEnter += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Entity_RowEnter);
            this.dgv_Entity.RowHeaderMouseClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgv_Entity_RowHeaderMouseClick);
            this.dgv_Entity.SelectionChanged += new System.EventHandler(this.dgv_Entity_SelectionChanged);
            // 
            // EntityId
            // 
            this.EntityId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.EntityId.DataPropertyName = "EntityId";
            dataGridViewCellStyle1.ForeColor = System.Drawing.Color.DarkGray;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.Color.LightGray;
            this.EntityId.DefaultCellStyle = dataGridViewCellStyle1;
            this.EntityId.HeaderText = "EntityId";
            this.EntityId.Name = "EntityId";
            this.EntityId.ReadOnly = true;
            this.EntityId.Width = 65;
            // 
            // EntityName
            // 
            this.EntityName.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.EntityName.DataPropertyName = "EntityName";
            this.EntityName.HeaderText = "EntityName";
            this.EntityName.Name = "EntityName";
            this.EntityName.Width = 200;
            // 
            // EntityDescription
            // 
            this.EntityDescription.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.EntityDescription.DataPropertyName = "EntityDescription";
            this.EntityDescription.HeaderText = "EntityDescription";
            this.EntityDescription.Name = "EntityDescription";
            // 
            // Entity_EntityTypeId
            // 
            this.Entity_EntityTypeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.Entity_EntityTypeId.DataPropertyName = "EntityTypeId";
            this.Entity_EntityTypeId.DataSource = this.entityTypeBindingSource;
            this.Entity_EntityTypeId.DisplayMember = "EntityTypeName";
            this.Entity_EntityTypeId.HeaderText = "EntityType";
            this.Entity_EntityTypeId.Name = "Entity_EntityTypeId";
            this.Entity_EntityTypeId.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Entity_EntityTypeId.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.Entity_EntityTypeId.ValueMember = "EntityTypeId";
            this.Entity_EntityTypeId.Width = 150;
            // 
            // entityTypeBindingSource
            // 
            this.entityTypeBindingSource.DataMember = "EntityType";
            this.entityTypeBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // Entity_StorageTypeId
            // 
            this.Entity_StorageTypeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.Entity_StorageTypeId.DataPropertyName = "StorageTypeId";
            this.Entity_StorageTypeId.DataSource = this.storageTypeBindingSource;
            this.Entity_StorageTypeId.DisplayMember = "StorageTypeName";
            this.Entity_StorageTypeId.HeaderText = "StorageType";
            this.Entity_StorageTypeId.Name = "Entity_StorageTypeId";
            this.Entity_StorageTypeId.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Entity_StorageTypeId.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.Entity_StorageTypeId.ValueMember = "StorageTypeId";
            this.Entity_StorageTypeId.Width = 150;
            // 
            // storageTypeBindingSource
            // 
            this.storageTypeBindingSource.DataMember = "StorageType";
            this.storageTypeBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // Entity_PartitioningTypeId
            // 
            this.Entity_PartitioningTypeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.Entity_PartitioningTypeId.DataPropertyName = "PartitioningTypeId";
            this.Entity_PartitioningTypeId.DataSource = this.partitioningTypeBindingSource;
            this.Entity_PartitioningTypeId.DisplayMember = "PartitioningTypeName";
            this.Entity_PartitioningTypeId.HeaderText = "PartitioningType";
            this.Entity_PartitioningTypeId.Name = "Entity_PartitioningTypeId";
            this.Entity_PartitioningTypeId.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Entity_PartitioningTypeId.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.Entity_PartitioningTypeId.ValueMember = "PartitioningTypeId";
            this.Entity_PartitioningTypeId.Width = 150;
            // 
            // partitioningTypeBindingSource
            // 
            this.partitioningTypeBindingSource.DataMember = "PartitioningType";
            this.partitioningTypeBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // CreateEntity
            // 
            this.CreateEntity.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.CreateEntity.DataPropertyName = "CreateEntity";
            this.CreateEntity.HeaderText = "CreateEntity";
            this.CreateEntity.Name = "CreateEntity";
            this.CreateEntity.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.CreateEntity.Width = 75;
            // 
            // Entity_LastUpdateTime
            // 
            this.Entity_LastUpdateTime.DataPropertyName = "LastUpdateTime";
            this.Entity_LastUpdateTime.HeaderText = "LastUpdateTime";
            this.Entity_LastUpdateTime.Name = "Entity_LastUpdateTime";
            this.Entity_LastUpdateTime.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Entity_LastUpdateTime.Visible = false;
            this.Entity_LastUpdateTime.Width = 141;
            // 
            // eDWEntityBindingSource
            // 
            this.eDWEntityBindingSource.DataMember = "EDWEntity";
            this.eDWEntityBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // grp_Attribute
            // 
            this.grp_Attribute.Controls.Add(this.btn_SaveAttribute);
            this.grp_Attribute.Controls.Add(this.btn_DeleteAttribute);
            this.grp_Attribute.Controls.Add(this.dgv_Attribute);
            this.grp_Attribute.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.grp_Attribute.Location = new System.Drawing.Point(4, 455);
            this.grp_Attribute.Margin = new System.Windows.Forms.Padding(4);
            this.grp_Attribute.Name = "grp_Attribute";
            this.grp_Attribute.Padding = new System.Windows.Forms.Padding(4);
            this.grp_Attribute.Size = new System.Drawing.Size(1328, 390);
            this.grp_Attribute.TabIndex = 1;
            this.grp_Attribute.TabStop = false;
            this.grp_Attribute.Text = "Attributes";
            // 
            // btn_SaveAttribute
            // 
            this.btn_SaveAttribute.Enabled = false;
            this.btn_SaveAttribute.Location = new System.Drawing.Point(227, 337);
            this.btn_SaveAttribute.Margin = new System.Windows.Forms.Padding(4);
            this.btn_SaveAttribute.Name = "btn_SaveAttribute";
            this.btn_SaveAttribute.Size = new System.Drawing.Size(121, 28);
            this.btn_SaveAttribute.TabIndex = 2;
            this.btn_SaveAttribute.Text = "Save Attributes";
            this.btn_SaveAttribute.UseVisualStyleBackColor = true;
            this.btn_SaveAttribute.Click += new System.EventHandler(this.btn_SaveAttribute_Click);
            // 
            // btn_DeleteAttribute
            // 
            this.btn_DeleteAttribute.Enabled = false;
            this.btn_DeleteAttribute.Location = new System.Drawing.Point(7, 337);
            this.btn_DeleteAttribute.Margin = new System.Windows.Forms.Padding(4);
            this.btn_DeleteAttribute.Name = "btn_DeleteAttribute";
            this.btn_DeleteAttribute.Size = new System.Drawing.Size(188, 28);
            this.btn_DeleteAttribute.TabIndex = 1;
            this.btn_DeleteAttribute.Text = "Delete Selected Attributes";
            this.btn_DeleteAttribute.UseVisualStyleBackColor = true;
            this.btn_DeleteAttribute.Click += new System.EventHandler(this.btn_DeleteAttribute_Click);
            // 
            // dgv_Attribute
            // 
            this.dgv_Attribute.AllowUserToDeleteRows = false;
            this.dgv_Attribute.AllowUserToOrderColumns = true;
            this.dgv_Attribute.AutoGenerateColumns = false;
            this.dgv_Attribute.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_Attribute.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.AttributeId,
            this.AttributeName,
            this.Attribute_EntityId,
            this.Attribute_DataTypeId,
            this.Order,
            this.IsStagingOnly,
            this.Attribute_LastUpdateTime,
            this.Attribute_LastChangeUserName});
            this.dgv_Attribute.DataSource = this.eDWAttributeBindingSource;
            this.dgv_Attribute.Dock = System.Windows.Forms.DockStyle.Top;
            this.dgv_Attribute.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgv_Attribute.Location = new System.Drawing.Point(4, 19);
            this.dgv_Attribute.Margin = new System.Windows.Forms.Padding(4);
            this.dgv_Attribute.Name = "dgv_Attribute";
            this.dgv_Attribute.Size = new System.Drawing.Size(1320, 310);
            this.dgv_Attribute.TabIndex = 0;
            this.dgv_Attribute.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Attribute_CellValueChanged);
            this.dgv_Attribute.DataError += new System.Windows.Forms.DataGridViewDataErrorEventHandler(this.dgv_Attribute_DataError);
            this.dgv_Attribute.RowEnter += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Attribute_RowEnter);
            this.dgv_Attribute.RowHeaderMouseClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgv_Attribute_RowHeaderMouseClick);
            // 
            // AttributeId
            // 
            this.AttributeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.AttributeId.DataPropertyName = "AttributeId";
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.DarkGray;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.Color.LightGray;
            this.AttributeId.DefaultCellStyle = dataGridViewCellStyle2;
            this.AttributeId.HeaderText = "AttributeId";
            this.AttributeId.Name = "AttributeId";
            this.AttributeId.ReadOnly = true;
            this.AttributeId.Width = 65;
            // 
            // AttributeName
            // 
            this.AttributeName.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.AttributeName.DataPropertyName = "AttributeName";
            this.AttributeName.HeaderText = "AttributeName";
            this.AttributeName.Name = "AttributeName";
            // 
            // Attribute_EntityId
            // 
            this.Attribute_EntityId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.Attribute_EntityId.DataPropertyName = "EDWEntityId";
            this.Attribute_EntityId.HeaderText = "EntityId";
            this.Attribute_EntityId.Name = "Attribute_EntityId";
            this.Attribute_EntityId.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Attribute_EntityId.Visible = false;
            this.Attribute_EntityId.Width = 200;
            // 
            // Attribute_DataTypeId
            // 
            this.Attribute_DataTypeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.Attribute_DataTypeId.DataPropertyName = "DataTypeId";
            this.Attribute_DataTypeId.DataSource = this.dataTypeBindingSource;
            this.Attribute_DataTypeId.DisplayMember = "DataTypeName";
            this.Attribute_DataTypeId.HeaderText = "DataType";
            this.Attribute_DataTypeId.Name = "Attribute_DataTypeId";
            this.Attribute_DataTypeId.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Attribute_DataTypeId.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.Attribute_DataTypeId.ValueMember = "DataTypeId";
            this.Attribute_DataTypeId.Width = 200;
            // 
            // dataTypeBindingSource
            // 
            this.dataTypeBindingSource.DataMember = "DataType";
            this.dataTypeBindingSource.DataSource = this.DVMeta_Entity;
            this.dataTypeBindingSource.Sort = "DataTypeName";
            // 
            // Order
            // 
            this.Order.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.Order.DataPropertyName = "Order";
            this.Order.HeaderText = "Order";
            this.Order.Name = "Order";
            this.Order.Width = 60;
            // 
            // IsStagingOnly
            // 
            this.IsStagingOnly.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.IsStagingOnly.DataPropertyName = "IsStagingOnly";
            this.IsStagingOnly.HeaderText = "StagingOnly";
            this.IsStagingOnly.Name = "IsStagingOnly";
            this.IsStagingOnly.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.IsStagingOnly.Width = 75;
            // 
            // Attribute_LastUpdateTime
            // 
            this.Attribute_LastUpdateTime.DataPropertyName = "LastUpdateTime";
            this.Attribute_LastUpdateTime.HeaderText = "LastUpdateTime";
            this.Attribute_LastUpdateTime.Name = "Attribute_LastUpdateTime";
            this.Attribute_LastUpdateTime.Visible = false;
            // 
            // Attribute_LastChangeUserName
            // 
            this.Attribute_LastChangeUserName.DataPropertyName = "LastChangeUserName";
            this.Attribute_LastChangeUserName.HeaderText = "LastChangeUserName";
            this.Attribute_LastChangeUserName.Name = "Attribute_LastChangeUserName";
            this.Attribute_LastChangeUserName.Visible = false;
            // 
            // eDWAttributeBindingSource
            // 
            this.eDWAttributeBindingSource.DataMember = "EDWAttribute";
            this.eDWAttributeBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // tabpg_Relationships
            // 
            this.tabpg_Relationships.Controls.Add(this.grp_EntityRelationship);
            this.tabpg_Relationships.Controls.Add(this.grp_EntityParent);
            this.tabpg_Relationships.Location = new System.Drawing.Point(4, 25);
            this.tabpg_Relationships.Margin = new System.Windows.Forms.Padding(4);
            this.tabpg_Relationships.Name = "tabpg_Relationships";
            this.tabpg_Relationships.Size = new System.Drawing.Size(1336, 849);
            this.tabpg_Relationships.TabIndex = 2;
            this.tabpg_Relationships.Text = "DV Relationships";
            this.tabpg_Relationships.UseVisualStyleBackColor = true;
            // 
            // grp_EntityRelationship
            // 
            this.grp_EntityRelationship.Controls.Add(this.btn_DeleteRelationship);
            this.grp_EntityRelationship.Controls.Add(this.dgv_EntityRelationship);
            this.grp_EntityRelationship.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.grp_EntityRelationship.Location = new System.Drawing.Point(0, 419);
            this.grp_EntityRelationship.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grp_EntityRelationship.Name = "grp_EntityRelationship";
            this.grp_EntityRelationship.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grp_EntityRelationship.Size = new System.Drawing.Size(1336, 430);
            this.grp_EntityRelationship.TabIndex = 1;
            this.grp_EntityRelationship.TabStop = false;
            this.grp_EntityRelationship.Text = "Entity Relationships";
            // 
            // btn_DeleteRelationship
            // 
            this.btn_DeleteRelationship.Location = new System.Drawing.Point(4, 373);
            this.btn_DeleteRelationship.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btn_DeleteRelationship.Name = "btn_DeleteRelationship";
            this.btn_DeleteRelationship.Size = new System.Drawing.Size(147, 28);
            this.btn_DeleteRelationship.TabIndex = 1;
            this.btn_DeleteRelationship.Text = "Delete Relationship";
            this.btn_DeleteRelationship.UseVisualStyleBackColor = true;
            this.btn_DeleteRelationship.Click += new System.EventHandler(this.btn_DeleteRelationship_Click);
            // 
            // dgv_EntityRelationship
            // 
            this.dgv_EntityRelationship.AllowUserToAddRows = false;
            this.dgv_EntityRelationship.AllowUserToDeleteRows = false;
            this.dgv_EntityRelationship.AllowUserToOrderColumns = true;
            this.dgv_EntityRelationship.AutoGenerateColumns = false;
            this.dgv_EntityRelationship.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_EntityRelationship.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.EntityRelationshipId,
            this.dataGridViewTextBoxColumn1,
            this.dataGridViewTextBoxColumn2,
            this.dataGridViewTextBoxColumn3,
            this.hashKeySuffixDataGridViewTextBoxColumn});
            this.dgv_EntityRelationship.DataSource = this.eDWEntityRelationshipExtendedBindingSource;
            this.dgv_EntityRelationship.Dock = System.Windows.Forms.DockStyle.Top;
            this.dgv_EntityRelationship.Location = new System.Drawing.Point(3, 17);
            this.dgv_EntityRelationship.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.dgv_EntityRelationship.Name = "dgv_EntityRelationship";
            this.dgv_EntityRelationship.ReadOnly = true;
            this.dgv_EntityRelationship.RowTemplate.Height = 24;
            this.dgv_EntityRelationship.Size = new System.Drawing.Size(1330, 350);
            this.dgv_EntityRelationship.TabIndex = 0;
            // 
            // EntityRelationshipId
            // 
            this.EntityRelationshipId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.EntityRelationshipId.DataPropertyName = "EntityRelationshipId";
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.DarkGray;
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.LightGray;
            this.EntityRelationshipId.DefaultCellStyle = dataGridViewCellStyle3;
            this.EntityRelationshipId.HeaderText = "Id";
            this.EntityRelationshipId.Name = "EntityRelationshipId";
            this.EntityRelationshipId.ReadOnly = true;
            this.EntityRelationshipId.Width = 65;
            // 
            // dataGridViewTextBoxColumn1
            // 
            this.dataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.dataGridViewTextBoxColumn1.DataPropertyName = "UsedBy_EntityId";
            this.dataGridViewTextBoxColumn1.HeaderText = "Related To (EntityId)";
            this.dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
            this.dataGridViewTextBoxColumn1.ReadOnly = true;
            this.dataGridViewTextBoxColumn1.Width = 150;
            // 
            // dataGridViewTextBoxColumn2
            // 
            this.dataGridViewTextBoxColumn2.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.dataGridViewTextBoxColumn2.DataPropertyName = "UsedBy_EntityTypeId";
            this.dataGridViewTextBoxColumn2.HeaderText = "Related To (EntityType)";
            this.dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
            this.dataGridViewTextBoxColumn2.ReadOnly = true;
            this.dataGridViewTextBoxColumn2.Width = 150;
            // 
            // dataGridViewTextBoxColumn3
            // 
            this.dataGridViewTextBoxColumn3.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.dataGridViewTextBoxColumn3.DataPropertyName = "UsedBy_EntityName";
            this.dataGridViewTextBoxColumn3.HeaderText = "Related To (EntityName)";
            this.dataGridViewTextBoxColumn3.Name = "dataGridViewTextBoxColumn3";
            this.dataGridViewTextBoxColumn3.ReadOnly = true;
            this.dataGridViewTextBoxColumn3.Width = 250;
            // 
            // hashKeySuffixDataGridViewTextBoxColumn
            // 
            this.hashKeySuffixDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.hashKeySuffixDataGridViewTextBoxColumn.DataPropertyName = "HashKeySuffix";
            this.hashKeySuffixDataGridViewTextBoxColumn.HeaderText = "HashKey Suffix";
            this.hashKeySuffixDataGridViewTextBoxColumn.Name = "hashKeySuffixDataGridViewTextBoxColumn";
            this.hashKeySuffixDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // eDWEntityRelationshipExtendedBindingSource
            // 
            this.eDWEntityRelationshipExtendedBindingSource.DataMember = "EDWEntityRelationshipExtended";
            this.eDWEntityRelationshipExtendedBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // grp_EntityParent
            // 
            this.grp_EntityParent.Controls.Add(this.btn_SaveRelationship);
            this.grp_EntityParent.Controls.Add(this.lbl_HashKeySuffix);
            this.grp_EntityParent.Controls.Add(this.lbl_RelatedTo);
            this.grp_EntityParent.Controls.Add(this.lbl_HubLnk);
            this.grp_EntityParent.Controls.Add(this.txt_HashKeySuffix);
            this.grp_EntityParent.Controls.Add(this.dgv_UsedBy);
            this.grp_EntityParent.Controls.Add(this.dgv_HubOrLnk);
            this.grp_EntityParent.Dock = System.Windows.Forms.DockStyle.Top;
            this.grp_EntityParent.Location = new System.Drawing.Point(0, 0);
            this.grp_EntityParent.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grp_EntityParent.Name = "grp_EntityParent";
            this.grp_EntityParent.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grp_EntityParent.Size = new System.Drawing.Size(1336, 354);
            this.grp_EntityParent.TabIndex = 0;
            this.grp_EntityParent.TabStop = false;
            // 
            // btn_SaveRelationship
            // 
            this.btn_SaveRelationship.Location = new System.Drawing.Point(4, 319);
            this.btn_SaveRelationship.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btn_SaveRelationship.Name = "btn_SaveRelationship";
            this.btn_SaveRelationship.Size = new System.Drawing.Size(147, 28);
            this.btn_SaveRelationship.TabIndex = 7;
            this.btn_SaveRelationship.Text = "Insert Relationship";
            this.btn_SaveRelationship.UseVisualStyleBackColor = true;
            this.btn_SaveRelationship.Click += new System.EventHandler(this.btn_SaveRelationship_Click);
            // 
            // lbl_HashKeySuffix
            // 
            this.lbl_HashKeySuffix.AutoSize = true;
            this.lbl_HashKeySuffix.Location = new System.Drawing.Point(1068, 17);
            this.lbl_HashKeySuffix.Name = "lbl_HashKeySuffix";
            this.lbl_HashKeySuffix.Size = new System.Drawing.Size(103, 17);
            this.lbl_HashKeySuffix.TabIndex = 6;
            this.lbl_HashKeySuffix.Text = "HashKey Suffix";
            // 
            // lbl_RelatedTo
            // 
            this.lbl_RelatedTo.AutoSize = true;
            this.lbl_RelatedTo.Location = new System.Drawing.Point(543, 17);
            this.lbl_RelatedTo.Name = "lbl_RelatedTo";
            this.lbl_RelatedTo.Size = new System.Drawing.Size(78, 17);
            this.lbl_RelatedTo.TabIndex = 5;
            this.lbl_RelatedTo.Text = "Related To";
            // 
            // lbl_HubLnk
            // 
            this.lbl_HubLnk.AutoSize = true;
            this.lbl_HubLnk.Location = new System.Drawing.Point(4, 17);
            this.lbl_HubLnk.Name = "lbl_HubLnk";
            this.lbl_HubLnk.Size = new System.Drawing.Size(64, 17);
            this.lbl_HubLnk.TabIndex = 4;
            this.lbl_HubLnk.Text = "Hub/Link";
            // 
            // txt_HashKeySuffix
            // 
            this.txt_HashKeySuffix.Location = new System.Drawing.Point(1072, 36);
            this.txt_HashKeySuffix.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.txt_HashKeySuffix.Name = "txt_HashKeySuffix";
            this.txt_HashKeySuffix.Size = new System.Drawing.Size(251, 22);
            this.txt_HashKeySuffix.TabIndex = 3;
            // 
            // dgv_UsedBy
            // 
            this.dgv_UsedBy.AllowUserToAddRows = false;
            this.dgv_UsedBy.AllowUserToDeleteRows = false;
            this.dgv_UsedBy.AllowUserToOrderColumns = true;
            this.dgv_UsedBy.AutoGenerateColumns = false;
            this.dgv_UsedBy.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.dgv_UsedBy.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_UsedBy.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.UsedBy_EntityId,
            this.UsedBy_EntityTypeId,
            this.UsedBy_EntityName});
            this.dgv_UsedBy.DataSource = this.eDWEntityBindingSource;
            this.dgv_UsedBy.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgv_UsedBy.Location = new System.Drawing.Point(543, 36);
            this.dgv_UsedBy.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.dgv_UsedBy.Name = "dgv_UsedBy";
            this.dgv_UsedBy.ReadOnly = true;
            this.dgv_UsedBy.RowTemplate.Height = 24;
            this.dgv_UsedBy.Size = new System.Drawing.Size(488, 277);
            this.dgv_UsedBy.TabIndex = 2;
            this.dgv_UsedBy.SelectionChanged += new System.EventHandler(this.dgv_UsedBy_SelectionChanged);
            // 
            // UsedBy_EntityId
            // 
            this.UsedBy_EntityId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.UsedBy_EntityId.DataPropertyName = "EntityId";
            dataGridViewCellStyle4.ForeColor = System.Drawing.Color.DarkGray;
            dataGridViewCellStyle4.SelectionForeColor = System.Drawing.Color.LightGray;
            this.UsedBy_EntityId.DefaultCellStyle = dataGridViewCellStyle4;
            this.UsedBy_EntityId.HeaderText = "EntityId";
            this.UsedBy_EntityId.Name = "UsedBy_EntityId";
            this.UsedBy_EntityId.ReadOnly = true;
            this.UsedBy_EntityId.Width = 65;
            // 
            // UsedBy_EntityTypeId
            // 
            this.UsedBy_EntityTypeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.UsedBy_EntityTypeId.DataPropertyName = "EntityTypeId";
            this.UsedBy_EntityTypeId.HeaderText = "EntityType";
            this.UsedBy_EntityTypeId.Name = "UsedBy_EntityTypeId";
            this.UsedBy_EntityTypeId.ReadOnly = true;
            this.UsedBy_EntityTypeId.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.UsedBy_EntityTypeId.Width = 80;
            // 
            // UsedBy_EntityName
            // 
            this.UsedBy_EntityName.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.UsedBy_EntityName.DataPropertyName = "EntityName";
            this.UsedBy_EntityName.HeaderText = "EntityName";
            this.UsedBy_EntityName.Name = "UsedBy_EntityName";
            this.UsedBy_EntityName.ReadOnly = true;
            // 
            // dgv_HubOrLnk
            // 
            this.dgv_HubOrLnk.AllowUserToAddRows = false;
            this.dgv_HubOrLnk.AllowUserToDeleteRows = false;
            this.dgv_HubOrLnk.AllowUserToOrderColumns = true;
            this.dgv_HubOrLnk.AutoGenerateColumns = false;
            this.dgv_HubOrLnk.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.dgv_HubOrLnk.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_HubOrLnk.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.HubOrLnk_EntityId,
            this.HubOrLnk_EntityTypeId,
            this.HubOrLnk_EntityName});
            this.dgv_HubOrLnk.DataSource = this.eDWEntityBindingSource;
            this.dgv_HubOrLnk.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgv_HubOrLnk.Location = new System.Drawing.Point(3, 36);
            this.dgv_HubOrLnk.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.dgv_HubOrLnk.MultiSelect = false;
            this.dgv_HubOrLnk.Name = "dgv_HubOrLnk";
            this.dgv_HubOrLnk.ReadOnly = true;
            this.dgv_HubOrLnk.RowHeadersVisible = false;
            this.dgv_HubOrLnk.RowTemplate.Height = 24;
            this.dgv_HubOrLnk.Size = new System.Drawing.Size(488, 277);
            this.dgv_HubOrLnk.TabIndex = 1;
            this.dgv_HubOrLnk.SelectionChanged += new System.EventHandler(this.dgv_HubOrLnk_SelectionChanged);
            // 
            // HubOrLnk_EntityId
            // 
            this.HubOrLnk_EntityId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.HubOrLnk_EntityId.DataPropertyName = "EntityId";
            dataGridViewCellStyle5.ForeColor = System.Drawing.Color.DarkGray;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.Color.LightGray;
            this.HubOrLnk_EntityId.DefaultCellStyle = dataGridViewCellStyle5;
            this.HubOrLnk_EntityId.HeaderText = "EntityId";
            this.HubOrLnk_EntityId.Name = "HubOrLnk_EntityId";
            this.HubOrLnk_EntityId.ReadOnly = true;
            this.HubOrLnk_EntityId.Width = 65;
            // 
            // HubOrLnk_EntityTypeId
            // 
            this.HubOrLnk_EntityTypeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.HubOrLnk_EntityTypeId.DataPropertyName = "EntityTypeId";
            this.HubOrLnk_EntityTypeId.HeaderText = "EntityType";
            this.HubOrLnk_EntityTypeId.Name = "HubOrLnk_EntityTypeId";
            this.HubOrLnk_EntityTypeId.ReadOnly = true;
            this.HubOrLnk_EntityTypeId.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.HubOrLnk_EntityTypeId.Width = 80;
            // 
            // HubOrLnk_EntityName
            // 
            this.HubOrLnk_EntityName.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.HubOrLnk_EntityName.DataPropertyName = "EntityName";
            this.HubOrLnk_EntityName.HeaderText = "EntityName";
            this.HubOrLnk_EntityName.Name = "HubOrLnk_EntityName";
            this.HubOrLnk_EntityName.ReadOnly = true;
            // 
            // tabpg_Processes
            // 
            this.tabpg_Processes.Controls.Add(this.grp_Process);
            this.tabpg_Processes.Controls.Add(this.grp_ProcessEntity);
            this.tabpg_Processes.Location = new System.Drawing.Point(4, 25);
            this.tabpg_Processes.Margin = new System.Windows.Forms.Padding(4);
            this.tabpg_Processes.Name = "tabpg_Processes";
            this.tabpg_Processes.Size = new System.Drawing.Size(1336, 849);
            this.tabpg_Processes.TabIndex = 3;
            this.tabpg_Processes.Text = "Processes";
            this.tabpg_Processes.UseVisualStyleBackColor = true;
            // 
            // grp_Process
            // 
            this.grp_Process.Controls.Add(this.btn_DeleteProcess);
            this.grp_Process.Controls.Add(this.btn_SaveProcess);
            this.grp_Process.Controls.Add(this.dgv_Process);
            this.grp_Process.Dock = System.Windows.Forms.DockStyle.Top;
            this.grp_Process.Location = new System.Drawing.Point(0, 0);
            this.grp_Process.Margin = new System.Windows.Forms.Padding(4);
            this.grp_Process.Name = "grp_Process";
            this.grp_Process.Padding = new System.Windows.Forms.Padding(4);
            this.grp_Process.Size = new System.Drawing.Size(1336, 398);
            this.grp_Process.TabIndex = 4;
            this.grp_Process.TabStop = false;
            this.grp_Process.Text = "Processes";
            // 
            // btn_DeleteProcess
            // 
            this.btn_DeleteProcess.Enabled = false;
            this.btn_DeleteProcess.Location = new System.Drawing.Point(4, 361);
            this.btn_DeleteProcess.Margin = new System.Windows.Forms.Padding(4);
            this.btn_DeleteProcess.Name = "btn_DeleteProcess";
            this.btn_DeleteProcess.Size = new System.Drawing.Size(191, 28);
            this.btn_DeleteProcess.TabIndex = 4;
            this.btn_DeleteProcess.Text = "Delete Selected Processes";
            this.btn_DeleteProcess.UseVisualStyleBackColor = true;
            this.btn_DeleteProcess.Click += new System.EventHandler(this.btn_DeleteProcess_Click);
            // 
            // btn_SaveProcess
            // 
            this.btn_SaveProcess.Enabled = false;
            this.btn_SaveProcess.Location = new System.Drawing.Point(227, 361);
            this.btn_SaveProcess.Margin = new System.Windows.Forms.Padding(4);
            this.btn_SaveProcess.Name = "btn_SaveProcess";
            this.btn_SaveProcess.Size = new System.Drawing.Size(148, 28);
            this.btn_SaveProcess.TabIndex = 3;
            this.btn_SaveProcess.Text = "Save Processes";
            this.btn_SaveProcess.UseVisualStyleBackColor = true;
            this.btn_SaveProcess.Click += new System.EventHandler(this.btn_SaveProcess_Click);
            // 
            // dgv_Process
            // 
            this.dgv_Process.AllowUserToDeleteRows = false;
            this.dgv_Process.AllowUserToOrderColumns = true;
            this.dgv_Process.AutoGenerateColumns = false;
            this.dgv_Process.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.dgv_Process.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_Process.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.ProcessId,
            this.ProcessName,
            this.ProcessDescription,
            this.ProcessTypeId,
            this.SourceSystemTypeId,
            this.ContactInfo,
            this.SupportGroup,
            this.dataGridViewTextBoxColumn5});
            this.dgv_Process.DataSource = this.processBindingSource;
            this.dgv_Process.Dock = System.Windows.Forms.DockStyle.Top;
            this.dgv_Process.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgv_Process.Location = new System.Drawing.Point(4, 19);
            this.dgv_Process.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.dgv_Process.Name = "dgv_Process";
            this.dgv_Process.RowTemplate.Height = 24;
            this.dgv_Process.Size = new System.Drawing.Size(1328, 335);
            this.dgv_Process.TabIndex = 0;
            this.dgv_Process.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Process_CellValueChanged);
            this.dgv_Process.DataError += new System.Windows.Forms.DataGridViewDataErrorEventHandler(this.dgv_Process_DataError);
            this.dgv_Process.RowEnter += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Process_RowEnter);
            this.dgv_Process.RowHeaderMouseClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgv_Process_RowHeaderMouseClick);
            this.dgv_Process.SelectionChanged += new System.EventHandler(this.dgv_Process_SelectionChanged);
            // 
            // ProcessId
            // 
            this.ProcessId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ProcessId.DataPropertyName = "ProcessId";
            dataGridViewCellStyle6.ForeColor = System.Drawing.Color.DarkGray;
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.Color.LightGray;
            this.ProcessId.DefaultCellStyle = dataGridViewCellStyle6;
            this.ProcessId.HeaderText = "ProcessId";
            this.ProcessId.Name = "ProcessId";
            this.ProcessId.ReadOnly = true;
            this.ProcessId.Width = 65;
            // 
            // ProcessName
            // 
            this.ProcessName.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ProcessName.DataPropertyName = "ProcessName";
            this.ProcessName.HeaderText = "ProcessName";
            this.ProcessName.Name = "ProcessName";
            this.ProcessName.Width = 150;
            // 
            // ProcessDescription
            // 
            this.ProcessDescription.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.ProcessDescription.DataPropertyName = "ProcessDescription";
            this.ProcessDescription.HeaderText = "ProcessDescription";
            this.ProcessDescription.Name = "ProcessDescription";
            // 
            // ProcessTypeId
            // 
            this.ProcessTypeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ProcessTypeId.DataPropertyName = "ProcessTypeId";
            this.ProcessTypeId.DataSource = this.processTypeBindingSource;
            this.ProcessTypeId.DisplayMember = "ProcessTypeName";
            this.ProcessTypeId.HeaderText = "ProcessType";
            this.ProcessTypeId.Name = "ProcessTypeId";
            this.ProcessTypeId.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.ProcessTypeId.ValueMember = "ProcessTypeId";
            // 
            // processTypeBindingSource
            // 
            this.processTypeBindingSource.DataMember = "ProcessType";
            this.processTypeBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // SourceSystemTypeId
            // 
            this.SourceSystemTypeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.SourceSystemTypeId.DataPropertyName = "SourceSystemTypeId";
            this.SourceSystemTypeId.DataSource = this.sourceSystemTypeBindingSource;
            this.SourceSystemTypeId.DisplayMember = "SourceSystemTypeName";
            this.SourceSystemTypeId.HeaderText = "SourceSystemType";
            this.SourceSystemTypeId.Name = "SourceSystemTypeId";
            this.SourceSystemTypeId.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.SourceSystemTypeId.ValueMember = "SourceSystemTypeId";
            // 
            // sourceSystemTypeBindingSource
            // 
            this.sourceSystemTypeBindingSource.DataMember = "SourceSystemType";
            this.sourceSystemTypeBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // ContactInfo
            // 
            this.ContactInfo.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ContactInfo.DataPropertyName = "ContactInfo";
            this.ContactInfo.HeaderText = "ContactInfo";
            this.ContactInfo.Name = "ContactInfo";
            this.ContactInfo.Width = 120;
            // 
            // SupportGroup
            // 
            this.SupportGroup.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.SupportGroup.DataPropertyName = "SupportGroup";
            this.SupportGroup.HeaderText = "SupportGroup";
            this.SupportGroup.Name = "SupportGroup";
            this.SupportGroup.Width = 180;
            // 
            // dataGridViewTextBoxColumn5
            // 
            this.dataGridViewTextBoxColumn5.DataPropertyName = "LastUpdateTime";
            this.dataGridViewTextBoxColumn5.HeaderText = "LastUpdateTime";
            this.dataGridViewTextBoxColumn5.Name = "dataGridViewTextBoxColumn5";
            this.dataGridViewTextBoxColumn5.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.dataGridViewTextBoxColumn5.Visible = false;
            this.dataGridViewTextBoxColumn5.Width = 141;
            // 
            // processBindingSource
            // 
            this.processBindingSource.DataMember = "Process";
            this.processBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // grp_ProcessEntity
            // 
            this.grp_ProcessEntity.Controls.Add(this.chk_ExcludeOtherProcess);
            this.grp_ProcessEntity.Controls.Add(this.btn_SaveProcessEntity);
            this.grp_ProcessEntity.Controls.Add(this.dgv_ProcessEntity);
            this.grp_ProcessEntity.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.grp_ProcessEntity.Location = new System.Drawing.Point(0, 455);
            this.grp_ProcessEntity.Margin = new System.Windows.Forms.Padding(4);
            this.grp_ProcessEntity.Name = "grp_ProcessEntity";
            this.grp_ProcessEntity.Padding = new System.Windows.Forms.Padding(4);
            this.grp_ProcessEntity.Size = new System.Drawing.Size(1336, 394);
            this.grp_ProcessEntity.TabIndex = 3;
            this.grp_ProcessEntity.TabStop = false;
            this.grp_ProcessEntity.Text = "Related Entities";
            // 
            // chk_ExcludeOtherProcess
            // 
            this.chk_ExcludeOtherProcess.AutoSize = true;
            this.chk_ExcludeOtherProcess.Location = new System.Drawing.Point(293, 345);
            this.chk_ExcludeOtherProcess.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.chk_ExcludeOtherProcess.Name = "chk_ExcludeOtherProcess";
            this.chk_ExcludeOtherProcess.Size = new System.Drawing.Size(249, 21);
            this.chk_ExcludeOtherProcess.TabIndex = 3;
            this.chk_ExcludeOtherProcess.Text = "Exclude related to other processes";
            this.chk_ExcludeOtherProcess.UseVisualStyleBackColor = true;
            this.chk_ExcludeOtherProcess.CheckedChanged += new System.EventHandler(this.chk_ExcludeOtherProcess_CheckedChanged);
            // 
            // btn_SaveProcessEntity
            // 
            this.btn_SaveProcessEntity.Enabled = false;
            this.btn_SaveProcessEntity.Location = new System.Drawing.Point(4, 337);
            this.btn_SaveProcessEntity.Margin = new System.Windows.Forms.Padding(4);
            this.btn_SaveProcessEntity.Name = "btn_SaveProcessEntity";
            this.btn_SaveProcessEntity.Size = new System.Drawing.Size(148, 28);
            this.btn_SaveProcessEntity.TabIndex = 2;
            this.btn_SaveProcessEntity.Text = "Save Relationship";
            this.btn_SaveProcessEntity.UseVisualStyleBackColor = true;
            this.btn_SaveProcessEntity.Click += new System.EventHandler(this.btn_SaveProcessEntity_Click);
            // 
            // dgv_ProcessEntity
            // 
            this.dgv_ProcessEntity.AllowUserToAddRows = false;
            this.dgv_ProcessEntity.AllowUserToDeleteRows = false;
            this.dgv_ProcessEntity.AllowUserToOrderColumns = true;
            this.dgv_ProcessEntity.AutoGenerateColumns = false;
            this.dgv_ProcessEntity.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_ProcessEntity.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.IsRelated,
            this.ProcessEntity_EntityId,
            this.ProcessEntity_EntityTypeId,
            this.ProcessEntity_EntityName});
            this.dgv_ProcessEntity.DataSource = this.eDWEntityExtendedBindingSource;
            this.dgv_ProcessEntity.Dock = System.Windows.Forms.DockStyle.Top;
            this.dgv_ProcessEntity.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgv_ProcessEntity.Location = new System.Drawing.Point(4, 19);
            this.dgv_ProcessEntity.Margin = new System.Windows.Forms.Padding(4);
            this.dgv_ProcessEntity.Name = "dgv_ProcessEntity";
            this.dgv_ProcessEntity.RowHeadersVisible = false;
            this.dgv_ProcessEntity.Size = new System.Drawing.Size(1328, 310);
            this.dgv_ProcessEntity.TabIndex = 0;
            this.dgv_ProcessEntity.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_ProcessEntity_CellContentClick);
            this.dgv_ProcessEntity.DataError += new System.Windows.Forms.DataGridViewDataErrorEventHandler(this.dgv_ProcessEntity_DataError);
            // 
            // IsRelated
            // 
            this.IsRelated.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.IsRelated.DataPropertyName = "IsRelated";
            this.IsRelated.HeaderText = "IsRelated";
            this.IsRelated.Name = "IsRelated";
            this.IsRelated.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            // 
            // ProcessEntity_EntityId
            // 
            this.ProcessEntity_EntityId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ProcessEntity_EntityId.DataPropertyName = "EntityId";
            this.ProcessEntity_EntityId.HeaderText = "EntityId";
            this.ProcessEntity_EntityId.Name = "ProcessEntity_EntityId";
            this.ProcessEntity_EntityId.ReadOnly = true;
            this.ProcessEntity_EntityId.Width = 65;
            // 
            // ProcessEntity_EntityTypeId
            // 
            this.ProcessEntity_EntityTypeId.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ProcessEntity_EntityTypeId.DataPropertyName = "EntityTypeId";
            this.ProcessEntity_EntityTypeId.HeaderText = "EntityType";
            this.ProcessEntity_EntityTypeId.Name = "ProcessEntity_EntityTypeId";
            this.ProcessEntity_EntityTypeId.ReadOnly = true;
            this.ProcessEntity_EntityTypeId.Width = 150;
            // 
            // ProcessEntity_EntityName
            // 
            this.ProcessEntity_EntityName.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.ProcessEntity_EntityName.DataPropertyName = "EntityName";
            this.ProcessEntity_EntityName.HeaderText = "EntityName";
            this.ProcessEntity_EntityName.Name = "ProcessEntity_EntityName";
            this.ProcessEntity_EntityName.ReadOnly = true;
            // 
            // eDWEntityExtendedBindingSource
            // 
            this.eDWEntityExtendedBindingSource.DataMember = "EDWEntityExtended";
            this.eDWEntityExtendedBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // tabpg_Deployment
            // 
            this.tabpg_Deployment.Controls.Add(this.grp_Result);
            this.tabpg_Deployment.Location = new System.Drawing.Point(4, 25);
            this.tabpg_Deployment.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.tabpg_Deployment.Name = "tabpg_Deployment";
            this.tabpg_Deployment.Size = new System.Drawing.Size(1336, 849);
            this.tabpg_Deployment.TabIndex = 4;
            this.tabpg_Deployment.Text = "Deployment";
            this.tabpg_Deployment.UseVisualStyleBackColor = true;
            // 
            // grp_Result
            // 
            this.grp_Result.Controls.Add(this.lbl_DeployResult);
            this.grp_Result.Controls.Add(this.btn_DeployModel);
            this.grp_Result.Controls.Add(this.tab_Validation);
            this.grp_Result.Dock = System.Windows.Forms.DockStyle.Fill;
            this.grp_Result.Location = new System.Drawing.Point(0, 0);
            this.grp_Result.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grp_Result.Name = "grp_Result";
            this.grp_Result.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grp_Result.Size = new System.Drawing.Size(1336, 849);
            this.grp_Result.TabIndex = 4;
            this.grp_Result.TabStop = false;
            this.grp_Result.Text = "Results";
            // 
            // lbl_DeployResult
            // 
            this.lbl_DeployResult.AutoSize = true;
            this.lbl_DeployResult.Location = new System.Drawing.Point(192, 762);
            this.lbl_DeployResult.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbl_DeployResult.Name = "lbl_DeployResult";
            this.lbl_DeployResult.Size = new System.Drawing.Size(0, 17);
            this.lbl_DeployResult.TabIndex = 5;
            // 
            // btn_DeployModel
            // 
            this.btn_DeployModel.Location = new System.Drawing.Point(8, 756);
            this.btn_DeployModel.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btn_DeployModel.Name = "btn_DeployModel";
            this.btn_DeployModel.Size = new System.Drawing.Size(111, 28);
            this.btn_DeployModel.TabIndex = 4;
            this.btn_DeployModel.Text = "Deploy Model";
            this.btn_DeployModel.UseVisualStyleBackColor = true;
            this.btn_DeployModel.Click += new System.EventHandler(this.btn_DeployModel_Click);
            // 
            // tab_Validation
            // 
            this.tab_Validation.Controls.Add(this.tabpg_Validation);
            this.tab_Validation.Controls.Add(this.tabpg_Result);
            this.tab_Validation.Dock = System.Windows.Forms.DockStyle.Top;
            this.tab_Validation.Location = new System.Drawing.Point(3, 17);
            this.tab_Validation.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.tab_Validation.Multiline = true;
            this.tab_Validation.Name = "tab_Validation";
            this.tab_Validation.SelectedIndex = 0;
            this.tab_Validation.Size = new System.Drawing.Size(1330, 729);
            this.tab_Validation.TabIndex = 2;
            // 
            // tabpg_Validation
            // 
            this.tabpg_Validation.Controls.Add(this.dgv_ValidateModel);
            this.tabpg_Validation.Location = new System.Drawing.Point(4, 25);
            this.tabpg_Validation.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.tabpg_Validation.Name = "tabpg_Validation";
            this.tabpg_Validation.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.tabpg_Validation.Size = new System.Drawing.Size(1322, 700);
            this.tabpg_Validation.TabIndex = 0;
            this.tabpg_Validation.Text = "Validation";
            this.tabpg_Validation.UseVisualStyleBackColor = true;
            // 
            // dgv_ValidateModel
            // 
            this.dgv_ValidateModel.AllowUserToAddRows = false;
            this.dgv_ValidateModel.AllowUserToDeleteRows = false;
            this.dgv_ValidateModel.AllowUserToOrderColumns = true;
            this.dgv_ValidateModel.AutoGenerateColumns = false;
            this.dgv_ValidateModel.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_ValidateModel.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.ruleIdDataGridViewTextBoxColumn1,
            this.ruleCategoryDataGridViewTextBoxColumn1,
            this.ruleNameDataGridViewTextBoxColumn1,
            this.reasonDataGridViewTextBoxColumn1,
            this.entityIdDataGridViewTextBoxColumn,
            this.entityTypeNameDataGridViewTextBoxColumn,
            this.entityNameDataGridViewTextBoxColumn});
            this.dgv_ValidateModel.DataSource = this.validateModelBindingSource;
            this.dgv_ValidateModel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgv_ValidateModel.Location = new System.Drawing.Point(3, 2);
            this.dgv_ValidateModel.Margin = new System.Windows.Forms.Padding(4);
            this.dgv_ValidateModel.Name = "dgv_ValidateModel";
            this.dgv_ValidateModel.ReadOnly = true;
            this.dgv_ValidateModel.RowHeadersVisible = false;
            this.dgv_ValidateModel.Size = new System.Drawing.Size(1316, 696);
            this.dgv_ValidateModel.TabIndex = 0;
            // 
            // ruleIdDataGridViewTextBoxColumn1
            // 
            this.ruleIdDataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ruleIdDataGridViewTextBoxColumn1.DataPropertyName = "RuleId";
            this.ruleIdDataGridViewTextBoxColumn1.HeaderText = "RuleId";
            this.ruleIdDataGridViewTextBoxColumn1.Name = "ruleIdDataGridViewTextBoxColumn1";
            this.ruleIdDataGridViewTextBoxColumn1.ReadOnly = true;
            this.ruleIdDataGridViewTextBoxColumn1.Width = 65;
            // 
            // ruleCategoryDataGridViewTextBoxColumn1
            // 
            this.ruleCategoryDataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ruleCategoryDataGridViewTextBoxColumn1.DataPropertyName = "RuleCategory";
            this.ruleCategoryDataGridViewTextBoxColumn1.HeaderText = "RuleCategory";
            this.ruleCategoryDataGridViewTextBoxColumn1.Name = "ruleCategoryDataGridViewTextBoxColumn1";
            this.ruleCategoryDataGridViewTextBoxColumn1.ReadOnly = true;
            this.ruleCategoryDataGridViewTextBoxColumn1.Width = 75;
            // 
            // ruleNameDataGridViewTextBoxColumn1
            // 
            this.ruleNameDataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.ruleNameDataGridViewTextBoxColumn1.DataPropertyName = "RuleName";
            this.ruleNameDataGridViewTextBoxColumn1.HeaderText = "RuleName";
            this.ruleNameDataGridViewTextBoxColumn1.Name = "ruleNameDataGridViewTextBoxColumn1";
            this.ruleNameDataGridViewTextBoxColumn1.ReadOnly = true;
            this.ruleNameDataGridViewTextBoxColumn1.Width = 175;
            // 
            // reasonDataGridViewTextBoxColumn1
            // 
            this.reasonDataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.reasonDataGridViewTextBoxColumn1.DataPropertyName = "Reason";
            this.reasonDataGridViewTextBoxColumn1.HeaderText = "Reason";
            this.reasonDataGridViewTextBoxColumn1.Name = "reasonDataGridViewTextBoxColumn1";
            this.reasonDataGridViewTextBoxColumn1.ReadOnly = true;
            // 
            // entityIdDataGridViewTextBoxColumn
            // 
            this.entityIdDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.entityIdDataGridViewTextBoxColumn.DataPropertyName = "EntityId";
            this.entityIdDataGridViewTextBoxColumn.HeaderText = "EntityId";
            this.entityIdDataGridViewTextBoxColumn.Name = "entityIdDataGridViewTextBoxColumn";
            this.entityIdDataGridViewTextBoxColumn.ReadOnly = true;
            this.entityIdDataGridViewTextBoxColumn.Width = 65;
            // 
            // entityTypeNameDataGridViewTextBoxColumn
            // 
            this.entityTypeNameDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.entityTypeNameDataGridViewTextBoxColumn.DataPropertyName = "EntityTypeName";
            this.entityTypeNameDataGridViewTextBoxColumn.HeaderText = "EntityType";
            this.entityTypeNameDataGridViewTextBoxColumn.Name = "entityTypeNameDataGridViewTextBoxColumn";
            this.entityTypeNameDataGridViewTextBoxColumn.ReadOnly = true;
            this.entityTypeNameDataGridViewTextBoxColumn.Width = 75;
            // 
            // entityNameDataGridViewTextBoxColumn
            // 
            this.entityNameDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.entityNameDataGridViewTextBoxColumn.DataPropertyName = "EntityName";
            this.entityNameDataGridViewTextBoxColumn.HeaderText = "EntityName";
            this.entityNameDataGridViewTextBoxColumn.Name = "entityNameDataGridViewTextBoxColumn";
            this.entityNameDataGridViewTextBoxColumn.ReadOnly = true;
            this.entityNameDataGridViewTextBoxColumn.Width = 200;
            // 
            // validateModelBindingSource
            // 
            this.validateModelBindingSource.DataMember = "ValidateModel";
            this.validateModelBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // tabpg_Result
            // 
            this.tabpg_Result.Controls.Add(this.txt_DeployMessage);
            this.tabpg_Result.Location = new System.Drawing.Point(4, 25);
            this.tabpg_Result.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.tabpg_Result.Name = "tabpg_Result";
            this.tabpg_Result.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.tabpg_Result.Size = new System.Drawing.Size(1322, 700);
            this.tabpg_Result.TabIndex = 1;
            this.tabpg_Result.Text = "Messages";
            this.tabpg_Result.UseVisualStyleBackColor = true;
            // 
            // txt_DeployMessage
            // 
            this.txt_DeployMessage.Dock = System.Windows.Forms.DockStyle.Fill;
            this.txt_DeployMessage.Location = new System.Drawing.Point(3, 2);
            this.txt_DeployMessage.Margin = new System.Windows.Forms.Padding(4);
            this.txt_DeployMessage.Multiline = true;
            this.txt_DeployMessage.Name = "txt_DeployMessage";
            this.txt_DeployMessage.ReadOnly = true;
            this.txt_DeployMessage.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.txt_DeployMessage.Size = new System.Drawing.Size(1316, 696);
            this.txt_DeployMessage.TabIndex = 0;
            // 
            // eDWEntityRelationshipBindingSource
            // 
            this.eDWEntityRelationshipBindingSource.DataMember = "EDWEntityRelationship";
            this.eDWEntityRelationshipBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // processEntityRelationshipBindingSource
            // 
            this.processEntityRelationshipBindingSource.DataMember = "ProcessEntityRelationship";
            this.processEntityRelationshipBindingSource.DataSource = this.DVMeta_Entity;
            // 
            // storageTypeTableAdapter
            // 
            this.storageTypeTableAdapter.ClearBeforeFill = true;
            // 
            // entityTypeTableAdapter
            // 
            this.entityTypeTableAdapter.ClearBeforeFill = true;
            // 
            // partitioningTypeTableAdapter
            // 
            this.partitioningTypeTableAdapter.ClearBeforeFill = true;
            // 
            // eDWAttributeTableAdapter
            // 
            this.eDWAttributeTableAdapter.ClearBeforeFill = true;
            // 
            // eDWEntityTableAdapter
            // 
            this.eDWEntityTableAdapter.ClearBeforeFill = true;
            // 
            // dataTypeTableAdapter
            // 
            this.dataTypeTableAdapter.ClearBeforeFill = true;
            // 
            // validateConfigurationTableAdapter
            // 
            this.validateConfigurationTableAdapter.ClearBeforeFill = true;
            // 
            // configurationTableAdapter
            // 
            this.configurationTableAdapter.ClearBeforeFill = true;
            // 
            // processTableAdapter
            // 
            this.processTableAdapter.ClearBeforeFill = true;
            // 
            // processEntityRelationshipTableAdapter
            // 
            this.processEntityRelationshipTableAdapter.ClearBeforeFill = true;
            // 
            // processTypeTableAdapter
            // 
            this.processTypeTableAdapter.ClearBeforeFill = true;
            // 
            // sourceSystemTypeTableAdapter
            // 
            this.sourceSystemTypeTableAdapter.ClearBeforeFill = true;
            // 
            // eDWEntityExtendedTableAdapter
            // 
            this.eDWEntityExtendedTableAdapter.ClearBeforeFill = true;
            // 
            // eDWEntityRelationshipTableAdapter
            // 
            this.eDWEntityRelationshipTableAdapter.ClearBeforeFill = true;
            // 
            // eDWEntityRelationshipExtendedTableAdapter
            // 
            this.eDWEntityRelationshipExtendedTableAdapter.ClearBeforeFill = true;
            // 
            // validateModelTableAdapter
            // 
            this.validateModelTableAdapter.ClearBeforeFill = true;
            // 
            // sts_Status
            // 
            this.sts_Status.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.sts_Status.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolsts_Connection});
            this.sts_Status.Location = new System.Drawing.Point(0, 853);
            this.sts_Status.Name = "sts_Status";
            this.sts_Status.Padding = new System.Windows.Forms.Padding(13, 0, 1, 0);
            this.sts_Status.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.sts_Status.Size = new System.Drawing.Size(1344, 25);
            this.sts_Status.TabIndex = 1;
            this.sts_Status.Text = "statusStrip1";
            // 
            // toolsts_Connection
            // 
            this.toolsts_Connection.Name = "toolsts_Connection";
            this.toolsts_Connection.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.toolsts_Connection.Size = new System.Drawing.Size(99, 20);
            this.toolsts_Connection.Text = "Disconnected";
            // 
            // Frm_Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1344, 878);
            this.Controls.Add(this.sts_Status);
            this.Controls.Add(this.tab_Main);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "Frm_Main";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Vault Meta Data Manager";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.tab_Main.ResumeLayout(false);
            this.tabpg_Connection.ResumeLayout(false);
            this.grp_Connection.ResumeLayout(false);
            this.grp_Connection.PerformLayout();
            this.tabpg_Configuration.ResumeLayout(false);
            this.grp_Configuration.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_configuration)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.configurationBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.DVMeta_Entity)).EndInit();
            this.grp_ConfigValidation.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ValidateConfig)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.validateConfigurationBindingSource)).EndInit();
            this.tabpg_Entities.ResumeLayout(false);
            this.grp_Entity.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Entity)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.entityTypeBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.storageTypeBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.partitioningTypeBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.eDWEntityBindingSource)).EndInit();
            this.grp_Attribute.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Attribute)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataTypeBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.eDWAttributeBindingSource)).EndInit();
            this.tabpg_Relationships.ResumeLayout(false);
            this.grp_EntityRelationship.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_EntityRelationship)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.eDWEntityRelationshipExtendedBindingSource)).EndInit();
            this.grp_EntityParent.ResumeLayout(false);
            this.grp_EntityParent.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_UsedBy)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_HubOrLnk)).EndInit();
            this.tabpg_Processes.ResumeLayout(false);
            this.grp_Process.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Process)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.processTypeBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.sourceSystemTypeBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.processBindingSource)).EndInit();
            this.grp_ProcessEntity.ResumeLayout(false);
            this.grp_ProcessEntity.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ProcessEntity)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.eDWEntityExtendedBindingSource)).EndInit();
            this.tabpg_Deployment.ResumeLayout(false);
            this.grp_Result.ResumeLayout(false);
            this.grp_Result.PerformLayout();
            this.tab_Validation.ResumeLayout(false);
            this.tabpg_Validation.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ValidateModel)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.validateModelBindingSource)).EndInit();
            this.tabpg_Result.ResumeLayout(false);
            this.tabpg_Result.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.eDWEntityRelationshipBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.processEntityRelationshipBindingSource)).EndInit();
            this.sts_Status.ResumeLayout(false);
            this.sts_Status.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TabControl tab_Main;
        private System.Windows.Forms.TabPage tabpg_Configuration;
        private System.Windows.Forms.TabPage tabpg_Entities;
        private System.Windows.Forms.TabPage tabpg_Relationships;
        private System.Windows.Forms.TabPage tabpg_Processes;
        private System.Windows.Forms.DataGridView dgv_configuration;
        private System.Windows.Forms.BindingSource configurationBindingSource;
        private DVMeta_EntityTableAdapters.ConfigurationTableAdapter configurationTableAdapter;
        private System.Windows.Forms.Button btn_SaveConfiguration;
        private System.Windows.Forms.GroupBox grp_ConfigValidation;
        private System.Windows.Forms.DataGridView dgv_ValidateConfig;
        private System.Windows.Forms.DataGridView dgv_Entity;
        private DVMeta_Entity DVMeta_Entity;
        private System.Windows.Forms.BindingSource eDWEntityBindingSource;
        private DVMeta_EntityTableAdapters.EDWEntityTableAdapter eDWEntityTableAdapter;
        private System.Windows.Forms.BindingSource entityTypeBindingSource;
        private DVMeta_EntityTableAdapters.EntityTypeTableAdapter entityTypeTableAdapter;
        private System.Windows.Forms.BindingSource storageTypeBindingSource;
        private DVMeta_EntityTableAdapters.StorageTypeTableAdapter storageTypeTableAdapter;
        private System.Windows.Forms.BindingSource partitioningTypeBindingSource;
        private DVMeta_EntityTableAdapters.PartitioningTypeTableAdapter partitioningTypeTableAdapter;
        private System.Windows.Forms.GroupBox grp_Attribute;
        private System.Windows.Forms.DataGridView dgv_Attribute;
        private System.Windows.Forms.BindingSource eDWAttributeBindingSource;
        private DVMeta_EntityTableAdapters.EDWAttributeTableAdapter eDWAttributeTableAdapter;
        private System.Windows.Forms.BindingSource dataTypeBindingSource;
        private DVMeta_EntityTableAdapters.DataTypeTableAdapter dataTypeTableAdapter;
        private System.Windows.Forms.GroupBox grp_Entity;
        private System.Windows.Forms.Button btn_SaveEntity;
        private System.Windows.Forms.Button btn_DeleteEntity;
        private System.Windows.Forms.BindingSource validateConfigurationBindingSource;
        private DVMeta_EntityTableAdapters.ValidateConfigurationTableAdapter validateConfigurationTableAdapter;
        private System.Windows.Forms.GroupBox grp_Configuration;
        private System.Windows.Forms.Button btn_SaveAttribute;
        private System.Windows.Forms.Button btn_DeleteAttribute;
        private System.Windows.Forms.GroupBox grp_Process;
        private System.Windows.Forms.Button btn_DeleteProcess;
        private System.Windows.Forms.Button btn_SaveProcess;
        private System.Windows.Forms.DataGridView dgv_Process;
        private System.Windows.Forms.GroupBox grp_ProcessEntity;
        private System.Windows.Forms.Button btn_SaveProcessEntity;
        private System.Windows.Forms.DataGridView dgv_ProcessEntity;
        private System.Windows.Forms.BindingSource processBindingSource;
        private DVMeta_EntityTableAdapters.ProcessTableAdapter processTableAdapter;
        private System.Windows.Forms.BindingSource processEntityRelationshipBindingSource;
        private DVMeta_EntityTableAdapters.ProcessEntityRelationshipTableAdapter processEntityRelationshipTableAdapter;
        private System.Windows.Forms.BindingSource processTypeBindingSource;
        private DVMeta_EntityTableAdapters.ProcessTypeTableAdapter processTypeTableAdapter;
        private System.Windows.Forms.BindingSource sourceSystemTypeBindingSource;
        private DVMeta_EntityTableAdapters.SourceSystemTypeTableAdapter sourceSystemTypeTableAdapter;
        private System.Windows.Forms.BindingSource eDWEntityExtendedBindingSource;
        private DVMeta_EntityTableAdapters.EDWEntityExtendedTableAdapter eDWEntityExtendedTableAdapter;
        private System.Windows.Forms.CheckBox chk_ExcludeOtherProcess;
        private System.Windows.Forms.GroupBox grp_EntityParent;
        private System.Windows.Forms.TabPage tabpg_Deployment;
        private System.Windows.Forms.GroupBox grp_Result;
        private System.Windows.Forms.Button btn_DeployModel;
        private System.Windows.Forms.TabControl tab_Validation;
        private System.Windows.Forms.TabPage tabpg_Validation;
        private System.Windows.Forms.TabPage tabpg_Result;
        private System.Windows.Forms.GroupBox grp_EntityRelationship;
        private System.Windows.Forms.DataGridView dgv_HubOrLnk;
        private System.Windows.Forms.DataGridView dgv_UsedBy;
        private System.Windows.Forms.DataGridView dgv_EntityRelationship;
        private System.Windows.Forms.BindingSource eDWEntityRelationshipBindingSource;
        private DVMeta_EntityTableAdapters.EDWEntityRelationshipTableAdapter eDWEntityRelationshipTableAdapter;
        private System.Windows.Forms.Label lbl_RelatedTo;
        private System.Windows.Forms.Label lbl_HubLnk;
        private System.Windows.Forms.TextBox txt_HashKeySuffix;
        private System.Windows.Forms.Label lbl_HashKeySuffix;
        private System.Windows.Forms.Button btn_SaveRelationship;
        private System.Windows.Forms.Button btn_DeleteRelationship;
        private System.Windows.Forms.BindingSource eDWEntityRelationshipExtendedBindingSource;
        private DVMeta_EntityTableAdapters.EDWEntityRelationshipExtendedTableAdapter eDWEntityRelationshipExtendedTableAdapter;
        private System.Windows.Forms.DataGridViewTextBoxColumn EntityRelationshipId;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn3;
        private System.Windows.Forms.DataGridViewTextBoxColumn hashKeySuffixDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn ruleIdDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn ruleCategoryDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn ruleNameDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn reasonDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn configurationIdDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn configurationValueDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridView dgv_ValidateModel;
        private System.Windows.Forms.BindingSource validateModelBindingSource;
        private DVMeta_EntityTableAdapters.ValidateModelTableAdapter validateModelTableAdapter;
        private System.Windows.Forms.DataGridViewTextBoxColumn ruleIdDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn ruleCategoryDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn ruleNameDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn reasonDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn entityIdDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn entityTypeNameDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn entityNameDataGridViewTextBoxColumn;
        private System.Windows.Forms.TextBox txt_DeployMessage;
        private System.Windows.Forms.Label lbl_DeployResult;
        private System.Windows.Forms.TabPage tabpg_Connection;
        private System.Windows.Forms.TextBox txt_ServerName;
        private System.Windows.Forms.Label lbl_ServerName;
        private System.Windows.Forms.Button btn_Connect;
        private System.Windows.Forms.ComboBox cmb_Authentication;
        private System.Windows.Forms.Label lbl_Authentication;
        private System.Windows.Forms.TextBox txt_Password;
        private System.Windows.Forms.TextBox txt_UserName;
        private System.Windows.Forms.Label lbl_Password;
        private System.Windows.Forms.Label lbl_UserName;
        private System.Windows.Forms.ComboBox cmb_Database;
        private System.Windows.Forms.Label lbl_Database;
        private System.Windows.Forms.Button btn_Start;
        private System.Windows.Forms.StatusStrip sts_Status;
        private System.Windows.Forms.ToolStripStatusLabel toolsts_Connection;
        private System.Windows.Forms.GroupBox grp_Connection;
        private System.Windows.Forms.Label lbl_Server;
        private System.Windows.Forms.DataGridViewTextBoxColumn Configuration_Id;
        private System.Windows.Forms.DataGridViewTextBoxColumn Configuration_Value;
        private System.Windows.Forms.DataGridViewTextBoxColumn Description;
        private System.Windows.Forms.DataGridViewTextBoxColumn EntityId;
        private System.Windows.Forms.DataGridViewTextBoxColumn EntityName;
        private System.Windows.Forms.DataGridViewTextBoxColumn EntityDescription;
        private System.Windows.Forms.DataGridViewComboBoxColumn Entity_EntityTypeId;
        private System.Windows.Forms.DataGridViewComboBoxColumn Entity_StorageTypeId;
        private System.Windows.Forms.DataGridViewComboBoxColumn Entity_PartitioningTypeId;
        private System.Windows.Forms.DataGridViewTextBoxColumn CreateEntity;
        private System.Windows.Forms.DataGridViewTextBoxColumn Entity_LastUpdateTime;
        private System.Windows.Forms.DataGridViewTextBoxColumn AttributeId;
        private System.Windows.Forms.DataGridViewTextBoxColumn AttributeName;
        private System.Windows.Forms.DataGridViewTextBoxColumn Attribute_EntityId;
        private System.Windows.Forms.DataGridViewComboBoxColumn Attribute_DataTypeId;
        private System.Windows.Forms.DataGridViewTextBoxColumn Order;
        private System.Windows.Forms.DataGridViewTextBoxColumn IsStagingOnly;
        private System.Windows.Forms.DataGridViewTextBoxColumn Attribute_LastUpdateTime;
        private System.Windows.Forms.DataGridViewTextBoxColumn Attribute_LastChangeUserName;
        private System.Windows.Forms.DataGridViewTextBoxColumn UsedBy_EntityId;
        private System.Windows.Forms.DataGridViewTextBoxColumn UsedBy_EntityTypeId;
        private System.Windows.Forms.DataGridViewTextBoxColumn UsedBy_EntityName;
        private System.Windows.Forms.DataGridViewTextBoxColumn HubOrLnk_EntityId;
        private System.Windows.Forms.DataGridViewTextBoxColumn HubOrLnk_EntityTypeId;
        private System.Windows.Forms.DataGridViewTextBoxColumn HubOrLnk_EntityName;
        private System.Windows.Forms.DataGridViewTextBoxColumn ProcessId;
        private System.Windows.Forms.DataGridViewTextBoxColumn ProcessName;
        private System.Windows.Forms.DataGridViewTextBoxColumn ProcessDescription;
        private System.Windows.Forms.DataGridViewComboBoxColumn ProcessTypeId;
        private System.Windows.Forms.DataGridViewComboBoxColumn SourceSystemTypeId;
        private System.Windows.Forms.DataGridViewTextBoxColumn ContactInfo;
        private System.Windows.Forms.DataGridViewTextBoxColumn SupportGroup;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn5;
        private System.Windows.Forms.DataGridViewCheckBoxColumn IsRelated;
        private System.Windows.Forms.DataGridViewTextBoxColumn ProcessEntity_EntityId;
        private System.Windows.Forms.DataGridViewTextBoxColumn ProcessEntity_EntityTypeId;
        private System.Windows.Forms.DataGridViewTextBoxColumn ProcessEntity_EntityName;
    }
}

