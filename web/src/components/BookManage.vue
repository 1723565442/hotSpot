<script>

export default {
    name: 'BookManege',
    data() {
        return {
            tableData: [],
            editDialogVisible: false,
            editForm: {
                title: '',
                label: '',
                author: '',
                introduction: '',
                url: '',
                text: '',
                image: '',
            },
            editingIndex: -1,
            uploadDialogVisible: false,
            uploadForm: {
                title: '',
                author: '',
                label: '',
                text: '',
                image: '',
                introduction: '',
                url: '',
            },
        };
    },
    created() {
        this.fetchBooks();
    },
    methods: {
        fetchBooks() {
            this.$http.get('http://localhost:8080/administrator/getallbook')
                .then(response => {
                    console.log('11111')
                    console.log(response)
                    response.data.data.forEach(book => {
                        book.rank = parseInt(book.rank);
                    });
                    response.data.data.sort((a, b) => a.rank - b.rank);
                    this.tableData = response.data.data;
                })
                .catch(error => {
                    console.error('Error fetching books', error);
                });
        },
        showDeleteConfirm(row) {
            this.$confirm(`确定要删除"${row.title}"吗？`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            })
                .then(() => {
                    // User clicked '确定', proceed with the delete
                    this.deleteRow(row);
                    this.$message({
                        type: 'success',
                        message: '删除成功!'
                    });
                })
                .catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
        },
        deleteRow(row) {
            const index = this.tableData.indexOf(row);
            if (index !== -1) {
                const deletedTitle = row.title; // Get the title of the deleted row
                this.$http.delete('http://localhost:8080/administrator/deletebook', {
                    data: {
                        title: deletedTitle
                    }
                })
                    .then(response => {
                        this.tableData = this.fetchBooks()
                    })
                    .catch(error => {
                        console.error('Error deleting book', error);
                    });
            }
        },
        showUploadDialog() {
            this.uploadDialogVisible = true;
        },
        resetUploadForm() {
            this.uploadForm = {
                title: '',
                label: '',
                author: '',
                introduction: '',
                url: '',
                text: '',
                image: '',
            };
        },
        uploadBook() {
            // Perform form validation
            this.$refs.uploadForm.validate((valid) => {
                if (valid) {
                    this.$http.post('http://localhost:8080/administrator/addbook', this.uploadForm).then((res) => {
                        this.tableData = this.fetchBooks();
                        this.uploadDialogVisible = false;
                        this.resetUploadForm();
                    }).catch((error) => {
                        ElNotification({
                            offset: 70,
                            title: '添加失败',
                            message: h('error', { style: 'color: teal' }, error.response),
                        })
                        console.log(error)
                    })

                } else {
                    // Form is not valid, display an error message or take other actions
                    this.$message({
                        type: 'error',
                        message: '请填写所有必填项',
                    });
                }
            });
        },
        handleImageUploadSuccess(response, file) {
            this.uploadForm.image = file.name;
        },
        handleImageEditSuccess(response, file) {
            this.editForm.image = file.name;
        },
        handleImageUploadErr(response, file) {
            console.log('文件名失败:', fileName);
        },
        beforeImageUpload(file) {
            const isImage = file.type.startsWith('image/');
            if (!isImage) {
                this.$message.error('请上传图片文件');
            }
            return isImage;
        },
        showEditDialog(row) {
            this.editDialogVisible = true;
            const book = row;
            this.editForm = {
                title: book.title,
                author: book.author,
                label: book.label,
                text: book.text,
                image: book.image,
                introduction: book.introduction,
                url: book.url,
            };
        },
        resetEditForm() {
            this.editForm = {
                title: '',
                author: '',
                label: '',
                text: '',
                image: '',
                introduction: '',
                url: '',
            };
            this.editingIndex = -1;
        },
        saveEditedBook() {
            this.$refs.editForm.validate((valid) => {
                if (valid) {
                    if (this.editingIndex !== -2) {
                        this.$http.put('http://localhost:8080/administrator/editbook', this.editForm)
                            .then(response => {
                                this.tableData = this.fetchBooks();
                                this.editDialogVisible = false;
                                this.resetEditForm();
                            })
                            .catch(error => {
                                // Handle errors
                                console.error('Error updating book', error);
                            });
                    }
                } else {
                    this.$message({
                        type: 'error',
                        message: '请填写所有必填项',
                    });
                }
            });
        },



    }


}


</script>


<template>
    <div class="bookManage" style="margin-left: 100px;margin-right: 100px;">
        <div class="title">
            <el-row>
                <el-col :span="18">
                    <p style="font-size: 24px; margin-left: 30px;">在架书籍</p>
                </el-col>
                <el-col :span="6">
                    <el-button type="success" style="margin-top: 20px; margin-left: 40px;" @click="showUploadDialog"> 上传<i
                            class="el-icon-upload el-icon--right"></i></el-button> </el-col>
            </el-row>
        </div>
        <el-dialog title="上传书籍" :visible.sync="uploadDialogVisible" width="50%" @closed="resetUploadForm">
            <el-form :model="uploadForm" ref="uploadForm" label-width="80px">
                <el-form-item label="书名" prop="title" :rules="[{ required: true, message: '请输入书名', trigger: 'blur' }]">
                    <el-input v-model="uploadForm.title"></el-input>
                </el-form-item>
                <el-form-item label="作者" prop="author" :rules="[{ required: true, message: '请输入作者', trigger: 'blur' }]">
                    <el-input v-model="uploadForm.author"></el-input>
                </el-form-item>
                <el-form-item label="标签" prop="label" :rules="[{ required: true, message: '请输入标签', trigger: 'blur' }]">
                    <el-input v-model="uploadForm.label"></el-input>
                </el-form-item>
                <el-form-item label="简介" prop="introduction"
                    :rules="[{ required: true, message: '请输入简介', trigger: 'blur' }]">
                    <el-input v-model="uploadForm.introduction"></el-input>
                </el-form-item>
                <el-form-item label="网址" prop="url" :rules="[{ required: true, message: '请输入源文件', trigger: 'blur' }]">
                    <el-input v-model="uploadForm.url"></el-input>
                </el-form-item>
                <el-form-item label="内容" prop="text" :rules="[{ required: true, message: '请输入内容', trigger: 'blur' }]">
                    <el-input type="textarea" :rows="6" v-model="uploadForm.text"></el-input>
                </el-form-item>
                <el-form-item label="图片上传">
                    <el-upload class="upload-demo" drag action="http://localhost:8080/administrator/upload"
                        :show-file-list="true" :on-success="handleImageUploadSuccess" :before-upload="beforeImageUpload"
                        :on-error="handleImageUploadErr" name="image">
                        <i class="el-icon-upload"></i>
                        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                        <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过10MB</div>
                    </el-upload>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="uploadBook">确认</el-button>
                    <el-button @click="uploadDialogVisible = false">取消</el-button>
                </el-form-item>
            </el-form>
        </el-dialog>
        <el-dialog title="编辑书籍" :visible.sync="editDialogVisible" width="50%" @closed="resetEditForm">
            <el-form :model="editForm" ref="editForm" label-width="100px">
                <el-form-item label="书名" prop="title" :rules="[{ required: true, message: '请输入书名', trigger: 'blur' }]">
                    <el-input v-model="editForm.title" :disabled="true"></el-input>
                </el-form-item>
                <el-form-item label="作者" prop="author" :rules="[{ required: true, message: '请输入作者', trigger: 'blur' }]">
                    <el-input v-model="editForm.author"></el-input>
                </el-form-item>
                <el-form-item label="标签" prop="label" :rules="[{ required: true, message: '请输入标签', trigger: 'blur' }]">
                    <el-input v-model="editForm.label"></el-input>
                </el-form-item>
                <el-form-item label="简介" prop="introduction"
                    :rules="[{ required: true, message: '请输入简介', trigger: 'blur' }]">
                    <el-input v-model="editForm.introduction"></el-input>
                </el-form-item>
                <el-form-item label="网址" prop="url" :rules="[{ required: true, message: '请输入书的源文件', trigger: 'blur' }]">
                    <el-input v-model="editForm.url"></el-input>
                </el-form-item>
                <el-form-item label="内容" prop="text" :rules="[{ required: true, message: '请输入内容', trigger: 'blur' }]">
                    <el-input type="textarea" v-model="editForm.text"></el-input>
                </el-form-item>
                <el-form-item label="图片上传">
                    <el-upload class="upload-demo1" drag action="http://localhost:8080/administrator/upload"
                        :show-file-list="true" :on-success="handleImageEditSuccess" :before-upload="beforeImageUpload"
                        :on-error="handleImageUploadErr" name="image">
                        <i class="el-icon-upload"></i>
                        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                        <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过10MB</div>
                    </el-upload>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="saveEditedBook">确认</el-button>
                    <el-button @click="editDialogVisible = false">取消</el-button>
                </el-form-item>
            </el-form>
        </el-dialog>
        <div class="list" style="margin-left: 30px;">
            <el-table :data="tableData"  stripe style="width: 100%">
                <el-table-column prop="rank" sortable label="排名" width="120">
                </el-table-column>
                <el-table-column prop="title" label="书名" width="180">
                </el-table-column>
                <el-table-column prop="author" label="作者" width="180">
                </el-table-column>
                <el-table-column prop="label" label="标签" width="180">
                </el-table-column>
                <el-table-column prop="updatedAt" label="上次修改" width="180">
                </el-table-column>
                <el-table-column label="操作" width="280">
                    <template slot-scope="scope">
                        <el-row>
                            <el-col :span="12">
                                <el-button type="primary" icon="el-icon-edit" @click="showEditDialog(scope.row)"
                                    round>编辑</el-button>
                            </el-col>
                            <el-col :span="12">
                                <el-button type="danger" icon="el-icon-delete" @click="showDeleteConfirm(scope.row)"
                                    round>删除</el-button>
                            </el-col>
                        </el-row>
                    </template>
                </el-table-column>
            </el-table>
        </div>
    </div>
</template>

<style scoped>
.title {
    text-align: start;
}
</style>

