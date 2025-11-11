package com.fly.model;

public class DetectionVO {
    private int detect_Id;
    private String CameraId;
    private String DetetType;
    private String ProgStatus;
    private String RegDt;
    private String CameraLoc;
    private String FileId;
    private String FileData;
    private String FileExt;

    // ✅ JSON 직렬화를 위해 Getter/Setter 필수
    public int getDetectId() { return detect_Id; }
    public void setDetectId(int detect_Id) { this.detect_Id = detect_Id; }

    public String getCameraId() { return CameraId; }
    public void setCameraId(String CameraId) { this.CameraId = CameraId; }

    public String getDetetType() { return DetetType; }
    public void setDetetType(String DetetType) { this.DetetType = DetetType; }

    public String getProgStatus() { return ProgStatus; }
    public void setProgStatus(String ProgStatus) { this.ProgStatus = ProgStatus; }

    public String getRegDt() { return RegDt; }
    public void setRegDt(String RegDt) { this.RegDt = RegDt; }

    public String getCameraLoc() { return CameraLoc; }
    public void setCameraLoc(String CameraLoc) { this.CameraLoc = CameraLoc; }
    
    public String FileId() { return FileId; }
    public void setFileId(String FileId) { this.FileId = FileId; }
    
    public String FileData() { return FileData; }
    public void setFileData(String FileData) { this.FileData = FileData; }
    
    public String FileExt() { return FileExt; }
    public void setFileExt(String FileExt) { this.FileExt = FileExt; }
}