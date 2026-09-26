# LiDAR + 9-axis IMU datasets in ROS bags

Researched 16 September 2026 using dataset-owner documentation and research papers. This is a broad discovery survey, not a claim of exhaustive coverage or an inspection of every downloadable bag. Large sensor recordings were not downloaded. Download links below are publisher landing pages; their documentation and listed links were checked, but each binary download was not tested.

## Inclusion criteria

The strict interpretation is recorded three-axis acceleration, three-axis angular velocity, and three-axis magnetic field, together with LiDAR measurements in ROS bags (possibly separate, synchronized bags). A sensor advertised as 9-axis is insufficient evidence that raw magnetic measurements were recorded. ROS `sensor_msgs/Imu` contains acceleration, angular velocity, and orientation, but no magnetic-field member: [official message definition](https://github.com/ros/common_msgs/blob/noetic-devel/sensor_msgs/msg/Imu.msg). Custom messages and separate `MagneticField` or `Vector3Stamped` topics can supply magnetometer data.

## Documented 3D LiDAR and recorded magnetometer matches

| Dataset / eligible subset | LiDAR | IMU / magnetic evidence | Format and access |
| --- | --- | --- | --- |
| [NTU VIRAL](https://ntu-aris.github.io/ntu_viral_dataset/) | Two Ouster OS1-16 Gen1 sensors | VectorNav VN100: `/imu/imu` and `/imu/magnetic_field`, both nominally 385 Hz. [Sensor/topic documentation](https://ntu-aris.github.io/ntu_viral_dataset/sensors_and_usage.html). | ROS 1 `.bag` recordings; 18 trajectory sequences listed; NTU repository and OneDrive links. |
| [RELLIS-3D — full-stack downloads](https://github.com/unmannedlab/RELLIS-3D#ros-bag-raw-data) | Ouster OS1-64 and Velodyne 32-channel | `/imu/data_raw` + `/imu/mag`; also VectorNav VN300 `/vectornav/IMU` + `/vectornav/Mag`. | ROS 1; select full-stack merged or split raw bags. The reduced “Synced data” downloads contain only selected camera/LiDAR topics. A 60-second full-stack merged example is listed as 4.2 GB. |
| [The Great Outdoors Dataset](https://github.com/unmannedlab/the-great-outdoors-dataset) | Ouster OS1-64 | `/lester/imu/data_raw` + `/lester/imu/mag` (`MagneticField`); MicroStrain AHRS setup | ROS 1 raw bags linked separately from processed semantic data. Distinct off-road dataset building on RELLIS-3D. |
| [CitrusFarm](https://ucr-robotics.github.io/Citrus-Farm-Dataset/download.html) | Velodyne point clouds | `/microstrain/imu/data` + `/microstrain/mag`; ZED2i IMU/magnetometer also available separately. | ROS 1; `base_*.bag` contains LiDAR, MicroStrain IMU and magnetic field together. Seven ground-robot sequences. |
| [M2UD](https://yaepiii.github.io/M2UD/Dataset/) | Velodyne `/velodyne_points`, 10 Hz | `/imu/data` 200 Hz + `/imu/mag` 100 Hz, explicitly acceleration, angular velocity, magnetometer. [Data format](https://yaepiii.github.io/M2UD/data-format/). | ROS bags; uneven-terrain ground-robot recordings; downloads on project site. |
| [MUN-FRL](https://mun-frl-vil-dataset.readthedocs.io/en/latest/) | Velodyne VLP-16 | `/imu/data` 400 Hz + `/imu/mag` 100 Hz; magnetic topic uses `geometry_msgs/Vector3Stamped`. [Sensor documentation](https://mun-frl-vil-dataset.readthedocs.io/en/latest/sensors.html). | ROS 1; aerial recordings from a helicopter and hexacopter; dataset site provides sequence downloads. |
| [MVSEC — outdoor driving](https://daniilidis-group.github.io/mvsec/download/) | `/velodyne_point_cloud` | `/visensor/imu` plus `/visensor/cust_imu`, a custom message containing magnetometer measurements. [Data format](https://daniilidis-group.github.io/mvsec/data_format/). | ROS 1; outdoor day/night driving sequences. Indoor flying has no VI-Sensor data; motorcycle has no LiDAR. The magnetic readings require the custom VI-Sensor message definition. |
| [Mag4D-SLAM](https://mag4d-dataset.github.io/Mag4d-Dataset/) | Livox Mid-360, `/lidar/points` | `/imu/data` + `/imu/mag`, documented as three magnetic components; LiDAR IMU plus separate 3DM-GX5 magnetic sensor, rather than requiring all measurements from one package | ROS 1 `raw.bag` plus CSV/point-cloud exports; project provides Google Drive downloads. Campus repeated traversals. Website inconsistently describes seven versus fourteen sequences, so no exact count is asserted here. |
| [FRUC forest recordings](https://zenodo.org/records/7819687), [additional Choupal release](https://zenodo.org/records/8139205) | Livox Mid-70 | Both deposits explicitly describe unfiltered accelerometer, gyroscope and magnetic data from Xsens MTi. | ROS 1; first deposit has `choupal_0.bag` through `choupal_2.bag`; second has an 8.5 GB `choupal.bag`. Treat the deposits as related releases, not automatically independent benchmark datasets. |
| [TIERS Multi-Modal LiDAR — OutdoorForest](https://github.com/TIERS/multi_modal_lidar_dataset) | Livox Avia, Livox Mid-360, Ouster OS0-128 | OutdoorForest bag metadata lists `/imu/data` and `/imu/mag`, both with 30,410 messages. | ROS 1; 23.59 GB; OneDrive/Baidu. Only OutdoorForest has documented magnetometer topics; the other listed sequences do not. Project is marked pre-release. |
| [NTNU Unified Autonomy Stack datasets](https://huggingface.co/datasets/ntnu-arl/unified_autonomy_stack_datasets) | Ouster OS0-128, RoboSense Airy, or Hesai JT-128 depending on platform | VN100 `/vectornav_driver_node/imu/data` + `/vectornav_driver_node/imu/mag`, both 200 Hz | ROS 1 `sensors_only.bag`; LiDAR stored as raw packets, with supplied conversion instructions for point clouds. Aerial, ground and handheld platforms. |
| [Mine and Forest Radar Dataset](https://github.com/kubelvla/mine-and-forest-radar-dataset), [Zenodo download](https://zenodo.org/records/21409692) | Ouster OS1-64 `/ouster/points` | Xsens MTi-30 `/imu/data` + `/imu/mag` (`Vector3Stamped`) | ROS 1, split into 5 GB parts. Old university file server is marked temporarily unavailable; Zenodo is the listed alternative. Heading output is not absolutely referenced to magnetometer north under the documented VRU profile. |
| [CTU heterogeneous cooperative UAV dataset — primary UAV](https://github.com/ctu-mrs/coop_uav_dataset) | Ouster OS0-128 Rev C, 10 Hz | Pixhawk `/uav12/mavros/imu/data_raw` 100 Hz + `/uav12/mavros/imu/mag` 85 Hz | ROS 1; primary circular/figure-eight bags listed as 5.19/7.97 GB. LiDAR packet decoding required. Select primary UAV recordings for 3D LiDAR. |
| [SEMFIRE — CTCV parking-lot subset](https://zenodo.org/records/5819064) | `/fused_point_cloud` | `/imu/data` + `/imu/mag` | ROS 1; eligible subset is `2020_ctcv_parking_lot_coimbra_rosbags`. Other subsets have different topic lists; do not assume all contain magnetic data or LiDAR. |
| [ITU heterogeneous robot team — ground vehicle](https://robotics.itu.edu.tr/ITU_Dataset/) | Velodyne VLP-16 | Xsens MTi-100; the authors’ paper Table 1 lists `/imu/data` and `/imu/mag` at 100 Hz. [Paper](https://www.researchgate.net/publication/338994418_A_3D_LiDAR_Dataset_of_ITU_Heterogeneous_Robot_Team). | ROS 1; ground-vehicle bags are linked via MEGA. The aerial topic list does not establish raw magnetometer availability. |
| [Örebro 4D Radar SLAM Challenge — public training run](https://github.com/RNP-lab/orebro_4d_radar_slam_challenge_data) | Leishen C32 `/cx/lslidar_point_cloud` | Xsens MTi-30 `/imu/data` + `/imu/mag` | ROS 2 Jazzy, MCAP. Choose `01_campus_training_localized`; evaluation run omits LiDAR. |

## Documented 2D LiDAR matches

| Dataset | Evidence | Format/access |
| --- | --- | --- |
| [Into the Dirt / ECHORD++ — ARSI aerial subset](https://robotics.upo.es/datasets/echord/) | Hokuyo/RPLIDAR scans; Pixhawk raw acceleration/gyro and `/imu/mag`. The [authors’ paper, section 5](https://robotics.upo.es/~lmercab/publications/papers/jfr20-preprint.pdf) documents the topics and warns that sewer magnetic interference is severe. | ROS 1; ARSI downloads, not SIAR ground-robot recordings. |
| [TurtleBot5G — MMK Corridor, KTH](https://zenodo.org/records/14995354) | `/scan`, `/imu`, `/magnetic_field` in documented bag metadata | ROS 2; files are restricted, so this is an access-controlled match rather than an immediately public download. |

## LiDAR bags from 9-axis/AHRS setups, but raw magnetometer not established

These can be useful when “9-axis” means acceleration, angular velocity and a usable orientation estimate, as in some SLAM workflows. Their public descriptions do not demonstrate all nine raw sensor channels inside the bags.

| Dataset | What is established / caveat |
| --- | --- |
| [LIO-SAM sample datasets](https://github.com/TixiaoShan/LIO-SAM#sample-datasets) | Author-provided ROS 1 bags and a MicroStrain 3DM-GX5-25 setup. Walking, Park, Garden, Rotation, Campus small/large are listed. Do not infer raw magnetic channels in all samples, especially the separate KITTI/Livox/Ouster examples. |
| [LVI-SAM](https://github.com/TixiaoShan/LVI-SAM#datasets) | ROS 1 bags from VLP-16 + MicroStrain 3DM-GX5-25 + camera/GPS setup; raw magnetic topic not documented. |
| [M2DGR](https://github.com/SJTU-ViSYS/M2DGR#sensor-setup) | VLP-32C and explicitly 9-axis Handsfree A9 at 150 Hz. Bag topic `/handsfree/imu`; no separate magnetic topic listed. |
| [UrbanV2X](https://polyu-taslab.github.io/UrbanV2X/download/) | LiDAR bags and explicitly 9-axis Xsens MTi-30; lists `/imu/data` as `sensor_msgs/Imu`, with no magnetic topic. |
| [VECtor — large-scale sequences](https://star-datasets.github.io/vector/download/) | Separate synchronized LiDAR and IMU bags. Calls `/imu/data` “Full 9-axis” but its `sensor_msgs/Imu` type cannot carry raw magnetic vectors. Select only sequences offering LiDAR downloads. |
| [GEODE](https://thisparticle.github.io/geode/) | LiDAR and Xsens MTi-30 ROS bags; exported IMU fields describe attitude, angular velocity and acceleration, not magnetic vectors. |
| [UrbanLoco](https://github.com/weisongwen/UrbanLoco) | Xsens MTi-10 AHRS and LiDAR bags; listed IMU topics only. Current README notes most Hong Kong data is supplied as ROS 2; check each download. |
| [UrbanNav](https://github.com/IPNL-POLYU/UrbanNavDataset) | LiDAR and Xsens AHRS `/imu/data` in ROS bags; no magnetic topic listed. |
| [Tesla Model 3 ROS data](https://huggingface.co/datasets/tfoldi/tesla3_av_rosbags) | VLP-16 and explicitly 9-axis IMU in ROS/MCAP recordings; card specifies acceleration, orientation and gyro, not magnetic vectors. |
| [Razor IMU / 2D LiDAR sensor-fusion recordings](https://github.com/mfilipen/sensor-fusion-lidar-imu) | Two ROS 1 recordings using 9DOF Razor IMU; `/imu` plus magnetic-derived yaw is described, not raw three-axis magnetometer messages. |
| [Leg-KILO](https://github.com/ouguangjun/legkilo-dataset) | ROS bags; authors use “9-axis” for acceleration, angular velocity and quaternion output. This is not evidence of a magnetometer channel. |
| [ConSLAM](https://github.com/mac137/ConSLAM) | Construction-site LiDAR/Xsens bags; the [paper](https://api.repository.cam.ac.uk/server/api/core/bitstreams/ae98fba2-c796-4632-93cc-64896a7e0c00/content) attributes magnetic fields to standard Imu messages, which conflicts with the message schema. Bag inspection needed. Repository warns about sequence 1. |
| [SFU Mountain](https://autonomy.cs.sfu.ca/sfu-mountain-dataset/) | SICK laser scanners, UM6 orientation/angular velocity/acceleration, original ROS bags; raw magnetic stream not established. |
| [NeBula Odometry](https://github.com/NeBula-Autonomy/nebula-odometry-dataset/blob/main/pages/dataset.md) | LiDAR bags plus VN100 `imu.bag`; recording of raw magnetometer channels not established. |
| [NTNU RIG](https://huggingface.co/datasets/ntnu-arl/rig_dataset) | LiDAR packets and VN100 IMU in ROS bags; documented topics list IMU/pressure but do not establish magnetometer. Distinct from the confirmed Unified Autonomy Stack collection. |

## Relevant datasets requiring conversion or further bag verification

- [CEAR](https://daroslab.github.io/cear/Downloads/): LiDAR in `lidar.bag`; VN100 accel/gyro/magnetometer in `vectornav.txt`. IMU conversion is required to obtain all modalities in bags. Backflip sequences omit LiDAR.
- [CODa](https://github.com/ut-amrl/coda-devkit/blob/main/docs/DATA_REPORT.md): Ouster/VectorNav sensor data with magnetic text exports. Public raw ROS bag distribution was not established from the [download workflow](https://github.com/ut-amrl/coda-devkit/blob/main/docs/GETTING_STARTED.md).
- [AAU Multi-Agent UVDAR](https://zenodo.org/records/13768604): platforms carried a planar LiDAR, and released metadata lists gyro/accel/mag and a rangefinder. It does not list raw planar laser scans; do not count it as confirmed scan data merely from the hardware description.

## Practical starting choices

For explicit raw magnetic data: start with NTU VIRAL (high-rate aerial IMU/magnetometer), CitrusFarm (LiDAR/IMU/mag together in base bags), RELLIS-3D (full-stack short sample), or M2UD (ground-robot uneven terrain). For ROS 2 3D LiDAR with a listed magnetic topic, use the Örebro training run.

For original LIO-SAM smoke testing, start with its own samples. LIO-SAM’s documented “9-axis” requirement concerns orientation output in addition to gyro and acceleration; presence of raw magnetometer messages alone does not establish compatibility. Extrinsics, point timestamps/rings, IMU rate and valid orientation still matter. [LIO-SAM requirements](https://github.com/TixiaoShan/LIO-SAM#prepare-imu-data).

After downloading, inspect actual bag topic types and message counts and sample magnetic vectors; topic documentation does not establish per-sequence data validity, calibration, or absence of dropouts.
