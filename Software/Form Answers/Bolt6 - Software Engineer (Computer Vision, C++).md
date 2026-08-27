### Tell us about a project that involves 3D geometry, calibration, SLAM, or numerical optimisation. 
For my MSc dissertation I built a real-time SLAM system on a Clearpath Husky using RTAB-Map, fusing LiDAR and radiological data for localisation and mapping in inspection scenarios.

On the hardware side, I worked out sensor placement for coverage and calibrated the LiDAR extrinsics to the robot base. This covered both the Velodyne VLP-16 and the Intel RealSense D435i.

For the SLAM work itself, I ran RTAB-Map, LIO-SAM, and Cartographer against each other under comparable conditions in ROS2, using rosbag2 to replay the same runs and compare how each one mapped and localised. 

Alongside that I wrote a ROS2 (rclcpp) point cloud pipeline in C++17 with PCL, which involved a fair bit of tf2 frame management and sorting out message synchronisation to stop transforms from arriving out of order.

I also configured Ceres, g2o, and GTSAM as solver backends and spent time tuning ICP parameters across different environments.

The bundle adjustment and solver work was at the configuration and tuning level within RTAB-Map, not something I implemented from scratch. Everything else above I built or ran directly.

### Which programming languages, frameworks, or tools do you like the most for computational geometry/optimisation/visual SLAM-style work, and why? 
C++ with Eigen for the math, Ceres or GTSAM for optimisation. The tight sensor-rate loops (scan matching, nearest-neighbour search) need C++; Python's overhead is too much there. Eigen keeps the linear algebra close to the actual math and still compiles down to something fast. Ceres works fine for general nonlinear least squares when there's no particular structure to exploit. GTSAM is different — it's built around factor graphs, so it exploits the sparsity that's already baked into most SLAM problems. If the problem is genuinely graph-shaped, I use GTSAM.