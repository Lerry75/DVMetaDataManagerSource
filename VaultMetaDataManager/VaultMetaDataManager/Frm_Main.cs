using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VaultMetaDataManager
{
    public partial class Frm_Main : Form
    {
        int _currentEntityId;
        string _currentEntityTypeId;
        int _currentProcessId;

        public Frm_Main()
        {
            InitializeComponent();
        }

        #region *** Form Load ***
        private void Form1_Load(object sender, EventArgs e)
        {
            RemoveTabPages();

            txt_ServerName.Text = Helper.GetServerName();
            cmb_Authentication.SelectedIndex = 0;
            txt_UserName.Text = Helper.GetUserName();
            txt_Password.Text = Helper.GetPassword();

            if (Helper.IsIntegratedSecurityConnection())
                cmb_Authentication.SelectedIndex = 0;
            else
                cmb_Authentication.SelectedIndex = 1;

            btn_SaveConfiguration.Enabled = false;
            btn_SaveEntity.Enabled = false;
            btn_DeleteEntity.Enabled = false;
            btn_SaveAttribute.Enabled = false;
            btn_DeleteAttribute.Enabled = false;
            btn_SaveProcess.Enabled = false;
            btn_DeleteProcess.Enabled = false;
            btn_SaveProcessEntity.Enabled = false;
        }

        private void RemoveTabPages()
        {
            if (tab_Main.TabCount == 6)
                for (int i = 1; i <= 5; i++)
                    tab_Main.TabPages.RemoveAt(1);
        }

        private void tab_Main_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (tab_Main.SelectedIndex)
            {
                case 1:
                    configurationTableAdapter.Fill(DVMeta_Entity.Configuration);
                    validateConfigurationTableAdapter.Fill(DVMeta_Entity.ValidateConfiguration);
                    break;
                case 2:
                    eDWEntityTableAdapter.Fill(DVMeta_Entity.EDWEntity);
                    break;
                case 3:
                    eDWEntityTableAdapter.Fill(DVMeta_Entity.EDWEntity);
                    dgv_HubOrLnk.DataSource = new DataView(DVMeta_Entity.EDWEntity, "EntityTypeId IN ('Hub', 'Lnk') ", "EntityId Asc", DataViewRowState.CurrentRows);
                    dgv_UsedBy.DataSource = new DataView(DVMeta_Entity.EDWEntity, "EntityTypeId NOT IN ('Hub')", "EntityId Asc", DataViewRowState.CurrentRows);
                    break;
                case 4:
                    sourceSystemTypeTableAdapter.Fill(DVMeta_Entity.SourceSystemType);
                    processTypeTableAdapter.Fill(DVMeta_Entity.ProcessType);
                    processTableAdapter.Fill(DVMeta_Entity.Process);
                    dgv_ProcessEntity.Sort(dgv_ProcessEntity.Columns["IsRelated"], ListSortDirection.Descending);
                    break;
                case 5:
                    validateModelTableAdapter.Fill(DVMeta_Entity.ValidateModel);
                    if (dgv_ValidateModel.RowCount == 0)
                        btn_DeployModel.Enabled = true;
                    else
                        btn_DeployModel.Enabled = false;

                    break;
            }
        }
        #endregion

        #region *** Connect Tab ***
        private void AddTabPages()
        {
            if (tab_Main.TabCount == 1)
            {
                tab_Main.TabPages.Add(tabpg_Configuration);
                tab_Main.TabPages.Add(tabpg_Entities);
                tab_Main.TabPages.Add(tabpg_Relationships);
                tab_Main.TabPages.Add(tabpg_Processes);
                tab_Main.TabPages.Add(tabpg_Deployment);
            }
        }

        private void LoadTableAdapters()
        {
            DVMeta_Entity.EDWAttribute.Clear();
            DVMeta_Entity.EDWEntityRelationship.Clear();
            DVMeta_Entity.EDWEntityRelationshipExtended.Clear();
            DVMeta_Entity.ProcessEntityRelationship.Clear();
            DVMeta_Entity.EDWEntity.Clear();
            DVMeta_Entity.EDWEntityExtended.Clear();
            DVMeta_Entity.Process.Clear();

            dataTypeTableAdapter.Fill(DVMeta_Entity.DataType);
            partitioningTypeTableAdapter.Fill(DVMeta_Entity.PartitioningType);
            storageTypeTableAdapter.Fill(DVMeta_Entity.StorageType);
            entityTypeTableAdapter.Fill(DVMeta_Entity.EntityType);
            configurationTableAdapter.Fill(DVMeta_Entity.Configuration);
            validateConfigurationTableAdapter.Fill(DVMeta_Entity.ValidateConfiguration);
        }

        private void SetAdapterConnectionString(string connectionstring)
        {
            configurationTableAdapter.Connection.ConnectionString = connectionstring;
            dataTypeTableAdapter.Connection.ConnectionString = connectionstring;
            eDWAttributeTableAdapter.Connection.ConnectionString = connectionstring;
            eDWEntityExtendedTableAdapter.Connection.ConnectionString = connectionstring;
            eDWEntityRelationshipExtendedTableAdapter.Connection.ConnectionString = connectionstring;
            eDWEntityRelationshipTableAdapter.Connection.ConnectionString = connectionstring;
            eDWEntityTableAdapter.Connection.ConnectionString = connectionstring;
            entityTypeTableAdapter.Connection.ConnectionString = connectionstring;
            partitioningTypeTableAdapter.Connection.ConnectionString = connectionstring;
            processEntityRelationshipTableAdapter.Connection.ConnectionString = connectionstring;
            processTableAdapter.Connection.ConnectionString = connectionstring;
            processTypeTableAdapter.Connection.ConnectionString = connectionstring;
            sourceSystemTypeTableAdapter.Connection.ConnectionString = connectionstring;
            storageTypeTableAdapter.Connection.ConnectionString = connectionstring;
            validateConfigurationTableAdapter.Connection.ConnectionString = connectionstring;
            validateModelTableAdapter.Connection.ConnectionString = connectionstring;
        }

        private void btn_Connect_Click(object sender, EventArgs e)
        {
            DataTable databases = null;

            btn_Connect.Enabled = false;
            cmb_Database.Enabled = false;
            cmb_Database.Items.Clear();
            btn_Start.Enabled = false;
            try
            {
                if (cmb_Authentication.SelectedIndex == 0)
                    databases = Helper.Connect(txt_ServerName.Text);
                else
                    databases = Helper.Connect(txt_ServerName.Text, txt_UserName.Text, txt_Password.Text);

                lbl_Server.Text = "Server ready.";
                lbl_Server.ForeColor = Color.Green;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);

                lbl_Server.Text = "Server not ready.";
                lbl_Server.ForeColor = Color.Red;
            }
            btn_Connect.Enabled = true;

            if (databases != null)
            {
                string currentdb = Helper.GetDatabaseName();
                int i = 0;
                foreach (DataRow row in databases.Rows)
                {
                    cmb_Database.Items.Add(row[0]);

                    if (row[0].ToString() == currentdb)
                        cmb_Database.SelectedIndex = i;

                    i++;
                }

                cmb_Database.Enabled = true;
            }
        }

        private void cmb_Authentication_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cmb_Authentication.SelectedIndex == 0)
            {
                txt_UserName.Enabled = false;
                txt_Password.Enabled = false;
            }
            else
            {
                txt_UserName.Enabled = true;
                txt_Password.Enabled = true;
            }
        }

        private void cmb_Database_SelectedIndexChanged(object sender, EventArgs e)
        {
            btn_Start.Enabled = true;
        }

        private void btn_Start_Click(object sender, EventArgs e)
        {
            RemoveTabPages();
            btn_Start.Enabled = false;
            try
            {
                string connstring = Helper.GetAdapterConnectionString(cmb_Database.Items[cmb_Database.SelectedIndex].ToString());
                SetAdapterConnectionString(connstring);
                LoadTableAdapters();
                AddTabPages();

                lbl_DeployResult.Text = string.Empty;
                txt_DeployMessage.Clear();
                toolsts_Connection.Text = string.Format("Connected to: {0}.{1}", Helper.GetServerName(), Helper.GetDatabaseName());
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);

                toolsts_Connection.Text = "Disconnected";
            }
            btn_Start.Enabled = true;
        }
        #endregion

        #region *** Configuration Tab ***
        private void btn_SaveConfiguration_Click(object sender, EventArgs e)
        {
            configurationBindingSource.EndEdit();

            using (DataTable dt = ((DataSet)configurationBindingSource.DataSource).Tables["Configuration"])
            using (DataTable changedTable = dt.GetChanges())
            {
                try
                {
                    if (changedTable != null)
                    {
                        foreach (DataRow row in changedTable.Rows)
                        {
                            if (row.RowState != DataRowState.Deleted)
                                configurationTableAdapter.Update((string)row["Id"], (string)row["Value"]);
                        }

                        dt.AcceptChanges();
                        configurationTableAdapter.Fill(DVMeta_Entity.Configuration);
                        validateConfigurationTableAdapter.Fill(DVMeta_Entity.ValidateConfiguration);

                        btn_SaveConfiguration.Enabled = false;
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    dt.RejectChanges();
                }
            }
        }

        private void dgv_Configuration_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            btn_SaveConfiguration.Enabled = true;
        }

        private void dgv_Configuration_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            foreach (DataGridViewRow row in dgv_configuration.Rows)
            {
                row.Cells["Configuration_Id"].ToolTipText = row.Cells["Description"].Value.ToString();
                row.Cells["Configuration_Value"].ToolTipText = row.Cells["Description"].Value.ToString();
            }
        }

        private void dgv_Configuration_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            MessageBox.Show(e.Exception.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        #endregion

        #region *** DV Entities Tab ***
        // Entities helpers
        private void dgv_Entity_SelectionChanged(object sender, EventArgs e)
        {
            if (dgv_Entity.CurrentRow != null)
            {
                if (dgv_Entity.CurrentRow.Cells["EntityId"].Value != null)
                {
                    _currentEntityId = (int)dgv_Entity.CurrentRow.Cells["EntityId"].Value;
                    _currentEntityTypeId = dgv_Entity.CurrentRow.Cells["Entity_EntityTypeId"].Value.ToString();
                }
                else
                {
                    _currentEntityId = -1;
                    _currentEntityTypeId = string.Empty;
                }

                if (eDWAttributeTableAdapter.Adapter != null)
                    eDWAttributeTableAdapter.FillByEntityId(DVMeta_Entity.EDWAttribute, _currentEntityId);

                if (_currentEntityTypeId == "Pit")
                    dgv_Attribute.Enabled = false;
                else
                    dgv_Attribute.Enabled = true;
            }
        }

        private void btn_SaveEntity_Click(object sender, EventArgs e)
        {
            eDWEntityBindingSource.EndEdit();

            using (DataTable dt = ((DataSet)eDWEntityBindingSource.DataSource).Tables["EDWEntity"])
            using (DataTable changedTable = dt.GetChanges())
            {
                try
                {
                    if (changedTable != null)
                    {
                        foreach (DataRow row in changedTable.Rows)
                        {
                            if (row.RowState != DataRowState.Deleted)
                            {
                                row["LastupdateTime"] = System.DateTime.UtcNow;
                                eDWEntityTableAdapter.Update(row);
                            }
                        }

                        dt.AcceptChanges();
                        eDWEntityTableAdapter.Fill(DVMeta_Entity.EDWEntity);
                        btn_SaveEntity.Enabled = false;
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    dt.RejectChanges();
                }
            }
        }

        private void dgv_Entity_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            btn_SaveEntity.Enabled = true;
        }

        private void dgv_Entity_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            MessageBox.Show(e.Exception.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private void dgv_Entity_RowHeaderMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (dgv_Entity.Rows[e.RowIndex].Selected)
                btn_DeleteEntity.Enabled = true;
            else
                btn_DeleteEntity.Enabled = false;
        }

        private void dgv_Entity_RowEnter(object sender, DataGridViewCellEventArgs e)
        {
            if (dgv_Entity.Rows[e.RowIndex].Selected)
                btn_DeleteEntity.Enabled = true;
            else
                btn_DeleteEntity.Enabled = false;
        }

        private void btn_DeleteEntity_Click(object sender, EventArgs e)
        {
            eDWEntityBindingSource.EndEdit();

            if (dgv_Entity.SelectedRows.Count != 0)
            {
                DialogResult res = MessageBox.Show("Entities will be deleted. Please confirm.", "Delete confirmation", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation);
                if (res == DialogResult.OK)
                {
                    try
                    {
                        foreach (DataGridViewRow item in dgv_Entity.SelectedRows)
                        {
                            int currentEntityId = int.Parse(item.Cells["EntityId"].Value.ToString());
                            string currentEntityName = item.Cells["EntityName"].Value.ToString();

                            if (eDWAttributeTableAdapter.CountByEntityId(currentEntityId) == 0)
                                if (eDWEntityRelationshipTableAdapter.CountByEntityId(currentEntityId) == 0)
                                    if (processEntityRelationshipTableAdapter.CountByEntityId(currentEntityId) == 0)
                                        eDWEntityTableAdapter.DeleteByEntityId(currentEntityId);
                                    else
                                        MessageBox.Show(string.Format("Cannot delete EntityId {0} ({1}).\nPlease delete process relationships in 'Processes' before.", currentEntityId, currentEntityName), 
                                            "Referenced entity", 
                                            MessageBoxButtons.OK, 
                                            MessageBoxIcon.Error);
                                else
                                    MessageBox.Show(string.Format("Cannot delete EntityId {0} ({1}).\nPlease delete entity relationships in 'DV Relationships' before.", currentEntityId, currentEntityName), 
                                        "Referenced entity", 
                                        MessageBoxButtons.OK, 
                                        MessageBoxIcon.Error);
                            else
                                MessageBox.Show(string.Format("Cannot delete EntityId {0} ({1}).\nPlease delete underlying attibutes before.", currentEntityId, currentEntityName), 
                                    "Referenced entity", 
                                    MessageBoxButtons.OK, 
                                    MessageBoxIcon.Error);
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }

                    eDWEntityTableAdapter.Fill(DVMeta_Entity.EDWEntity);
                }
            }
        }

        // Attribute helpers
        private void btn_SaveAttribute_Click(object sender, EventArgs e)
        {
            eDWEntityBindingSource.EndEdit();
            eDWAttributeBindingSource.EndEdit();

            using (DataTable dt = ((DataSet)eDWEntityBindingSource.DataSource).Tables["EDWEntity"])
            using (DataTable changedTable = dt.GetChanges())
            using (DataTable dt_attrib = ((DataSet)eDWAttributeBindingSource.DataSource).Tables["EDWAttribute"])
            using (DataTable changedTable_attrib = dt_attrib.GetChanges())
            {
                try
                {
                    bool newRowAdded = false;
                    if (changedTable != null)
                    {
                        foreach (DataRow row in changedTable.Rows)
                        {
                            if (row.RowState == DataRowState.Added)
                            {
                                eDWEntityTableAdapter.InsertGetEntityId(
                                    row["EntityName"].ToString(),
                                    row["EntityDescription"].ToString(),
                                    row["EntityTypeId"].ToString(),
                                    row["StorageTypeId"].ToString(),
                                    row["PartitioningTypeId"].ToString(),
                                    (bool)row["CreateEntity"],
                                    DateTime.UtcNow.ToString("yyyy-MM-dd hh:mm:ss"),
                                    out _currentEntityId);

                                _currentEntityTypeId = row["EntityTypeId"].ToString();
                            }
                        }
                    }

                    try
                    {
                        if (changedTable_attrib != null)
                        {
                            foreach (DataRow row in changedTable_attrib.Rows)
                            {
                                if (row.RowState != DataRowState.Deleted)
                                {
                                    row["EDWEntityId"] = _currentEntityId;
                                    row["LastupdateTime"] = DateTime.UtcNow;
                                    eDWAttributeTableAdapter.Update(row);
                                }
                            }

                            dt.AcceptChanges();
                            dt_attrib.AcceptChanges();
                            btn_SaveAttribute.Enabled = false;

                            if (newRowAdded)
                                eDWEntityTableAdapter.Fill(DVMeta_Entity.EDWEntity);
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        dt_attrib.RejectChanges();
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    dt.RejectChanges();
                }
            }
        }

        private void btn_DeleteAttribute_Click(object sender, EventArgs e)
        {
            eDWAttributeBindingSource.EndEdit();

            if (dgv_Attribute.SelectedRows.Count != 0)
            {
                DialogResult res = MessageBox.Show("Attributes will be deleted. Please confirm.", "Delete confirmation", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation);
                if (res == DialogResult.OK)
                {
                    try
                    {
                        foreach (DataGridViewRow item in dgv_Attribute.SelectedRows)
                        {
                            eDWAttributeTableAdapter.DeleteByAttributeId(int.Parse(item.Cells["AttributeId"].Value.ToString()));
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }

                    eDWAttributeTableAdapter.FillByEntityId(DVMeta_Entity.EDWAttribute, _currentEntityId);
                }
            }
        }

        private void dgv_Attribute_RowEnter(object sender, DataGridViewCellEventArgs e)
        {
            if (dgv_Attribute.Rows[e.RowIndex].Cells["Attribute_EntityId"].Value == null)
                dgv_Attribute.Rows[e.RowIndex].Cells["Attribute_EntityId"].Value = _currentEntityId;

            if (dgv_Attribute.Rows[e.RowIndex].Selected)
                btn_DeleteAttribute.Enabled = true;
            else
                btn_DeleteAttribute.Enabled = false;
        }

        private void dgv_Attribute_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            btn_SaveAttribute.Enabled = true;
        }

        private void dgv_Attribute_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            MessageBox.Show(e.Exception.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private void dgv_Attribute_RowHeaderMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (dgv_Attribute.Rows[e.RowIndex].Selected)
                btn_DeleteAttribute.Enabled = true;
            else
                btn_DeleteAttribute.Enabled = false;
        }
        #endregion

        #region *** DV Relationships Tab ***
        private void dgv_HubOrLnk_SelectionChanged(object sender, EventArgs e)
        {
            if (dgv_HubOrLnk.CurrentRow != null)
            {
                dgv_HubOrLnk.CurrentRow.Selected = true;

                if (dgv_HubOrLnk.CurrentRow.Cells["HubOrLnk_EntityId"].Value != null)
                {
                    eDWEntityRelationshipExtendedTableAdapter.FillByEntityId(DVMeta_Entity.EDWEntityRelationshipExtended, int.Parse(dgv_HubOrLnk.CurrentRow.Cells["HubOrLnk_EntityId"].Value.ToString()));
                }
            }
        }

        private void dgv_UsedBy_SelectionChanged(object sender, EventArgs e)
        {
            if (dgv_UsedBy.CurrentRow != null)
            {
                dgv_UsedBy.CurrentRow.Selected = true;
            }
        }

        private void btn_SaveRelationship_Click(object sender, EventArgs e)
        {
            if ((dgv_HubOrLnk.CurrentRow != null) && (dgv_UsedBy.CurrentRow != null))
            {
                int hubOrLnk = int.Parse(dgv_HubOrLnk.CurrentRow.Cells["HubOrLnk_EntityId"].Value.ToString());

                try
                {
                    foreach (DataGridViewRow row in dgv_UsedBy.SelectedRows)
                        eDWEntityRelationshipTableAdapter.Insert(
                            hubOrLnk,
                            int.Parse(row.Cells["UsedBy_EntityId"].Value.ToString()),
                            txt_HashKeySuffix.Text,
                            DateTime.UtcNow.ToString("yyyy-MM-dd hh:mm:ss"));
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }

                txt_HashKeySuffix.Text = string.Empty;
                eDWEntityRelationshipExtendedTableAdapter.FillByEntityId(DVMeta_Entity.EDWEntityRelationshipExtended, hubOrLnk);
            }
        }

        private void btn_DeleteRelationship_Click(object sender, EventArgs e)
        {
            if (dgv_EntityRelationship.SelectedRows.Count != 0)
            {
                DialogResult res = MessageBox.Show("Entity relationships will be deleted. Please confirm.", "Delete confirmation", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation);
                if (res == DialogResult.OK)
                {
                    try
                    {
                        foreach (DataGridViewRow item in dgv_EntityRelationship.SelectedRows)
                        {
                            eDWEntityRelationshipTableAdapter.DeleteById(int.Parse(item.Cells["EntityRelationshipId"].Value.ToString()));
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }

                    eDWEntityRelationshipExtendedTableAdapter.FillByEntityId(DVMeta_Entity.EDWEntityRelationshipExtended, int.Parse(dgv_HubOrLnk.CurrentRow.Cells["HubOrLnk_EntityId"].Value.ToString()));
                }
            }
        }
        #endregion

        #region *** Processes tab ***
        // Process helpers
        private void dgv_Process_SelectionChanged(object sender, EventArgs e)
        {
            if (dgv_Process.CurrentRow != null)
            {
                if (dgv_Process.CurrentRow.Cells["ProcessId"].Value != null)
                {
                    _currentProcessId = (int)dgv_Process.CurrentRow.Cells["ProcessId"].Value;
                }
                else
                {
                    _currentProcessId = -1;
                }

                if (eDWEntityExtendedTableAdapter.Adapter != null)
                {
                    if (chk_ExcludeOtherProcess.Checked)
                        eDWEntityExtendedTableAdapter.FillByProcessIdExcludeOthers(DVMeta_Entity.EDWEntityExtended, _currentProcessId);
                    else
                        eDWEntityExtendedTableAdapter.FillByProcessId(DVMeta_Entity.EDWEntityExtended, _currentProcessId);
                }

            }
        }

        private void btn_DeleteProcess_Click(object sender, EventArgs e)
        {
            processBindingSource.EndEdit();

            if (dgv_Process.SelectedRows.Count != 0)
            {
                DialogResult res = MessageBox.Show("Processes and underlying relationships will be deleted. Please confirm.", "Delete confirmation", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation);
                if (res == DialogResult.OK)
                {
                    try
                    {
                        foreach (DataGridViewRow item in dgv_Process.SelectedRows)
                        {
                            int currentProcessId = int.Parse(item.Cells["ProcessId"].Value.ToString());
                            processEntityRelationshipTableAdapter.DeleteByProcessId(currentProcessId);
                            processTableAdapter.DeleteByProcessId(currentProcessId);
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }

                    processTableAdapter.Fill(DVMeta_Entity.Process);
                }

            }
        }

        private void btn_SaveProcess_Click(object sender, EventArgs e)
        {
            processBindingSource.EndEdit();

            using (DataTable dt = ((DataSet)processBindingSource.DataSource).Tables["Process"])
            using (DataTable changedTable = dt.GetChanges())
            {
                try
                {
                    if (changedTable != null)
                    {
                        foreach (DataRow row in changedTable.Rows)
                        {
                            if (row.RowState != DataRowState.Deleted)
                            {
                                row["LastupdateTime"] = System.DateTime.UtcNow;
                                processTableAdapter.Update(row);
                            }
                        }

                        dt.AcceptChanges();
                        processTableAdapter.Fill(DVMeta_Entity.Process);
                        btn_SaveProcess.Enabled = false;
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    dt.RejectChanges();
                }
            }
        }

        private void dgv_Process_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            btn_SaveProcess.Enabled = true;
        }

        private void dgv_Process_RowHeaderMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (dgv_Process.Rows[e.RowIndex].Selected)
                btn_DeleteProcess.Enabled = true;
            else
                btn_DeleteProcess.Enabled = false;
        }

        private void dgv_Process_RowEnter(object sender, DataGridViewCellEventArgs e)
        {
            if (dgv_Process.Rows[e.RowIndex].Selected)
                btn_DeleteProcess.Enabled = true;
            else
                btn_DeleteProcess.Enabled = false;
        }

        private void dgv_Process_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            MessageBox.Show(e.Exception.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        // ProcessEntity helpers
        private void dgv_ProcessEntity_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            MessageBox.Show(e.Exception.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private void chk_ExcludeOtherProcess_CheckedChanged(object sender, EventArgs e)
        {
            if (eDWEntityExtendedTableAdapter.Adapter != null)
            {
                if (chk_ExcludeOtherProcess.Checked)
                    eDWEntityExtendedTableAdapter.FillByProcessIdExcludeOthers(DVMeta_Entity.EDWEntityExtended, _currentProcessId);
                else
                    eDWEntityExtendedTableAdapter.FillByProcessId(DVMeta_Entity.EDWEntityExtended, _currentProcessId);
            }
        }

        private void btn_SaveProcessEntity_Click(object sender, EventArgs e)
        {
            processBindingSource.EndEdit();
            eDWEntityExtendedBindingSource.EndEdit();

            using (DataTable dt = ((DataSet)processBindingSource.DataSource).Tables["Process"])
            using (DataTable changedTable = dt.GetChanges())
            using (DataTable dt_attrib = ((DataSet)eDWEntityExtendedBindingSource.DataSource).Tables["EDWEntityExtended"])
            using (DataTable changedTable_attrib = dt_attrib.GetChanges())
            {
                try
                {
                    bool newRowAdded = false;
                    if (changedTable != null)
                    {
                        foreach (DataRow row in changedTable.Rows)
                        {
                            if (row.RowState == DataRowState.Added)
                            {
                                processTableAdapter.InsertGetProcessId(
                                    row["ProcessName"].ToString(),
                                    row["ProcessDescription"].ToString(),
                                    row["ProcessTypeId"].ToString(),
                                    row["SourceSystemTypeId"].ToString(),
                                    row["ContactInfo"].ToString(),
                                    row["SupportGroup"].ToString(),
                                    DateTime.UtcNow.ToString("yyyy-MM-dd hh:mm:ss"),
                                    out _currentProcessId);

                                newRowAdded = true;
                            }
                        }
                    }

                    try
                    {
                        if (changedTable_attrib != null)
                        {
                            processEntityRelationshipTableAdapter.DeleteByProcessId(_currentProcessId);

                            foreach (DataGridViewRow row in dgv_ProcessEntity.Rows)
                            {
                                if ((bool)row.Cells["IsRelated"].Value)
                                    processEntityRelationshipTableAdapter.Insert(
                                        _currentProcessId,
                                        int.Parse(row.Cells["ProcessEntity_EntityId"].Value.ToString()),
                                        DateTime.UtcNow.ToString("yyyy-MM-dd hh:mm:ss"));
                            }

                            dt.AcceptChanges();
                            dt_attrib.AcceptChanges();
                            btn_SaveProcessEntity.Enabled = false;

                            if (newRowAdded)
                                processTableAdapter.Fill(DVMeta_Entity.Process);
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        dt_attrib.RejectChanges();
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    dt.RejectChanges();
                }
            }
        }

        private void dgv_ProcessEntity_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == dgv_ProcessEntity.Columns["IsRelated"].Index)
                btn_SaveProcessEntity.Enabled = true;
        }
        #endregion

        #region *** Deployment Tab ***
        private void btn_DeployModel_Click(object sender, EventArgs e)
        {
            string result = string.Empty;
            bool error = false;
            tab_Validation.SelectedTab = tabpg_Result;
            lbl_DeployResult.Text = string.Empty;
            txt_DeployMessage.Text = string.Format("Deploying to {0}.{1}...\r\n\r\n", Helper.GetServerName(), Helper.GetDatabaseName());
            btn_DeployModel.Enabled = false;
            Application.DoEvents();
            DVMetaAdapter adap = new DVMetaAdapter(validateModelTableAdapter);

            try
            {
                txt_DeployMessage.Text += adap.CreateModel(false, out result, out error);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            lbl_DeployResult.Text = result;
            if (error)
                lbl_DeployResult.ForeColor = Color.Red;
            else
                lbl_DeployResult.ForeColor = Color.Black;

            txt_DeployMessage.Select(0, 0);
            btn_DeployModel.Enabled = true;
        }
        #endregion

    }
}
