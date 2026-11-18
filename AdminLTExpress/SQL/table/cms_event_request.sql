CREATE TABLE IF NOT EXISTS cms_event_request (
 id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 requested_by INT NOT NULL,
 reviewed_by INT NULL,
 action_key VARCHAR(180) NOT NULL,
 payload_json LONGTEXT NOT NULL,
 reason TEXT NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'pending',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 reviewed_at DATETIME NULL,
 executed_at DATETIME NULL,
 review_note TEXT NULL,
 result_json LONGTEXT NULL,
 error_message TEXT NULL,
 INDEX idx_status (status, id),
 INDEX idx_requester (requested_by, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Assign roles using VERIFIED account IDs. Do not run with placeholder IDs.
-- UPDATE admin_user SET roles = '[0]' WHERE id = <HANG_ACCOUNT_ID>;
-- UPDATE admin_user SET roles = '[1]' WHERE id IN (<QA_ID>, <DEV_ID>);
