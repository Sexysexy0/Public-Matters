// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SovereignEHRVault.sol";

/**
 * @title PatientConsentEngine
 * @notice Codifies Issues #67, #68, #69.
 *         Provides revocable time-bound access delegation and appointment scheduling.
 */
contract PatientConsentEngine {

    struct Consent {
        bool isGranted;
        uint256 expiryTimestamp;
    }

    struct Appointment {
        address doctor;
        uint256 appointmentTime;
        bool isConfirmed;
    }

    // Patient => Doctor => Consent details
    mapping(address => mapping(address => Consent)) public doctorConsents;
    // Patient => Appointments List
    mapping(address => Appointment[]) private patientAppointments;

    event ConsentGranted(address indexed patient, address indexed doctor, uint256 expiry);
    event ConsentRevoked(address indexed patient, address indexed doctor);
    event AppointmentBooked(address indexed patient, address indexed doctor, uint256 appointmentTime);

    /**
     * @notice Grant time-bound medical access to doctor (Issue #69)
     */
    function grantConsent(address doctor, uint256 durationInSeconds) external {
        uint256 expiry = block.timestamp + durationInSeconds;
        doctorConsents[msg.sender][doctor] = Consent({
            isGranted: true,
            expiryTimestamp: expiry
        });

        emit ConsentGranted(msg.sender, doctor, expiry);
    }

    /**
     * @notice Revoke doctor access immediately (Issue #69)
     */
    function revokeConsent(address doctor) external {
        doctorConsents[msg.sender][doctor].isGranted = false;
        emit ConsentRevoked(msg.sender, doctor);
    }

    /**
     * @notice Verify if doctor currently holds active non-expired consent
     */
    function hasActiveConsent(address patient, address doctor) external view returns (bool) {
        Consent memory c = doctorConsents[patient][doctor];
        return (c.isGranted && block.timestamp <= c.expiryTimestamp);
    }

    /**
     * @notice Schedule appointment module (Issue #67)
     */
    function bookAppointment(address doctor, uint256 appointmentTime) external {
        patientAppointments[msg.sender].push(Appointment({
            doctor: doctor,
            appointmentTime: appointmentTime,
            isConfirmed: true
        }));

        emit AppointmentBooked(msg.sender, doctor, appointmentTime);
    }
}
